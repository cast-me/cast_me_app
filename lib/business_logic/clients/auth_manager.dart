import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/clients/analytics.dart';
import 'package:cast_me_app/business_logic/clients/supabase_helpers.dart';
import 'package:cast_me_app/business_logic/models/cast_me_tab.dart';
import 'package:cast_me_app/business_logic/models/protobufs/cast_me_profile_base.pb.dart';
import 'package:cast_me_app/util/color_utils.dart';
import 'package:cast_me_app/util/string_utils.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:palette_generator/palette_generator.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Notifies when the Firebase auth state changes or the CastMe user changes.
///
/// TODO(caseycrogers): Refactor to use `AsyncActionWrapper`.
class AuthManager extends ChangeNotifier {
  AuthManager._() {
    _setAndListenForRegistrationToken();
    supabase.auth.onAuthStateChange((event, session) async {
      if (event == AuthChangeEvent.passwordRecovery &&
          _signInState != SignInState.settingNewPassword) {
        _signInState = SignInState.settingNewPassword;
        notifyListeners();
      }
      if (_signInState == SignInState.verifyingEmail &&
          event == AuthChangeEvent.signedIn) {
        // Edge case to catch when the user has externally verified
        // their email.
        _signInState = SignInState.completingProfile;
        notifyListeners();
      }
      if (event == AuthChangeEvent.signedIn &&
          _signInState == SignInState.signingInThroughProvider) {
        await _completeSignIn(false);
        notifyListeners();
      }
    });
    // Listen for changes to ourself to update the registration token.
    addListener(_setAndListenForRegistrationToken);
  }

  static final AuthManager instance = AuthManager._();

  final SignInBloc signInBloc = SignInBloc._();

  Profile? _profile;

  Profile get profile => _profile!;

  // Should not be accessed before verifying that the user manager has loaded.
  SignInState? _signInState = SignInState.signingIn;

  SignInState get signInState => _signInState!;

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  bool _isProcessing = false;

  // Whether or not we're processing info and waiting for an async callback.
  // Submit buttons in sign up flow should be disabled while this is true.
  bool get isProcessing => _isProcessing;

  bool get isFullySignedIn => _signInState == SignInState.signedIn;

  Object? _authError;

  Object? get authError => _authError;

  bool _hasRegisteredFcmToken = false;

  void toggleResetPassword() {
    assert(_signInState == SignInState.signingIn);
    _signInState = SignInState.resettingPassword;
    notifyListeners();
  }

  void toggleAccountRegistrationFlow() {
    if (signInState == SignInState.registering ||
        signInState == SignInState.resettingPassword) {
      _signInState = SignInState.signingIn;
    } else if (signInState == SignInState.signingIn) {
      _signInState = SignInState.registering;
    } else {
      throw Exception(
        'Cannot toggle between sign in and registering from state:'
        ' $_signInState',
      );
    }
    notifyListeners();
  }

  Future<void> createUser({
    required String email,
    required String password,
  }) async {
    await _authActionWrapper(
      'createUser',
      () async {
        try {
          await supabase.auth
              .signUp(
                email,
                password,
                options: const AuthOptions(redirectTo: 'com.cast.me.app'),
              )
              .errorToException();
        } on GoTrueException catch (e) {
          // Hack to catch an erroneous error.
          // TODO(caseycrogers): remove this catch once the issue is resolved:
          // https://github.com/supabase-community/supabase-flutter/issues/182
          if (e.statusCode != null) {
            rethrow;
          }
        }
        Analytics.instance.logSignUp(email: email);
        _signInState = SignInState.verifyingEmail;
      },
    );
  }

  Future<void> completeUserProfile({
    required String username,
    required String displayName,
    required File profilePicture,
  }) async {
    await _authActionWrapper(
      'completeUserProfile',
      () async {
        Analytics.instance.logCompleteProfile(user: supabase.auth.currentUser!);
        assert(
          supabase.auth.currentUser != null,
          'You are not properly logged in, please report this error.',
        );
        // There's a bug in supabase storage where it only understands jpeg.
        // https://github.com/supabase-community/supabase-flutter/issues/213
        final String fileExt = profilePicture.path.split('.').last;
        // Anonymize the file name so we don't get naming conflicts.
        final String fileName = '${DateTime.now().toIso8601String()}.$fileExt';
        final Uint8List imageBytes = await profilePicture.readAsBytes();
        await profilePicturesBucket.uploadBinary(
          fileName,
          imageBytes,
          fileOptions: FileOptions(
            contentType: lookupMimeType(profilePicture.path),
          ),
        );
        final String profilePictureUrl =
            profilePicturesBucket.getPublicUrl(fileName);
        final PaletteGenerator paletteGenerator =
            await PaletteGenerator.fromImageProvider(MemoryImage(imageBytes));
        final Profile completedProfile = Profile(
          id: supabase.auth.currentUser!.id,
          username: username,
          displayName: displayName,
          profilePictureUrl: profilePictureUrl,
          accentColorBase: paletteGenerator.vibrantColor?.color.serialize,
        );
        await profilesQuery.upsert(completedProfile.toSQLJson());
        _profile = completedProfile;
        _signInState = SignInState.signedIn;
      },
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _authActionWrapper(
      'signIn',
      () async {
        bool emailNotConfirmed = false;
        try {
          await supabase.auth
              .signIn(
                email: email,
                password: password,
              )
              .errorToException();
        } catch (e) {
          if (e is GoTrueException &&
              e.message.contains('Email not confirmed')) {
            emailNotConfirmed = true;
          } else {
            rethrow;
          }
        }
        await _completeSignIn(emailNotConfirmed);
      },
    );
    if (supabase.auth.currentUser != null) {
      Analytics.instance.logSignIn(user: supabase.auth.currentUser);
    }
  }

  Future<void> _completeSignIn(bool requiresEmailConfirmation) async {
    if (requiresEmailConfirmation) {
      _signInState = SignInState.verifyingEmail;
      return;
    }
    _profile = await _fetchCurrentProfile();
    if (_profile == null) {
      _signInState = SignInState.completingProfile;
    } else {
      _signInState = SignInState.signedIn;
    }
  }

  Future<void> handlePop(
    SignInState poppedState,
    SignInState stateAfterPop,
  ) async {
    if (supabase.auth.currentUser != null) {
      // If we were signed in, make sure we sign out first.
      // This is really only applicable to the `CompletingProfile` and
      // `SettingNewPassword` states.
      return signOut(returnState: stateAfterPop);
    }
    _signInState = stateAfterPop;
    notifyListeners();
  }

  Future<void> signOut({
    SignInState returnState = SignInState.signingIn,
  }) async {
    Analytics.instance.logSignOut(user: supabase.auth.currentUser!);
    await _authActionWrapper(
      'signOut',
      () async {
        await supabase.auth.signOut().errorToException();
        _profile = null;
        _signInState = returnState;
      },
    );
    // Also reset the current tab so that the user goes back to home if they log
    // back in.
    CastMeBloc.instance.onTabChanged(CastMeTab.listen);
  }

  Future<void> setNewPassword({required String newPassword}) async {
    Analytics.instance.logSetNewPassword(user: supabase.auth.currentUser!);
    await _authActionWrapper('reset password', () async {
      await supabase.auth.update(UserAttributes(password: newPassword));
      await _completeSignIn(false);
    });
  }

  Future<void> sendResetPasswordEmail({required String email}) async {
    Analytics.instance.logSendResetPasswordEmail(email: email);
    await _authActionWrapper('reset password', () async {
      await supabase.auth.api.resetPasswordForEmail(
        email,
        options: const AuthOptions(
            redirectTo: 'io.supabase.castmeapp://reset-callback/'),
      );
    });
  }

  Future<void> initialize() async {
    final User? user = supabase.auth.currentUser;
    if (user == null) {
      _profile = null;
      _signInState = SignInState.signingIn;
    } else {
      _profile = await _fetchCurrentProfile();
      if (user.emailConfirmedAt == null) {
        _signInState = SignInState.verifyingEmail;
      } else if (_profile == null) {
        _signInState = SignInState.completingProfile;
      } else {
        _signInState = SignInState.signedIn;
      }
    }
    _isInitialized = true;
    notifyListeners();
  }

  Future<List<Profile>> searchForProfiles({
    required String startsWith,
  }) async {
    final result = await profilesQuery
        .select()
        .or('$usernameCol.ilike.$startsWith%,'
            '$displayNameCol.ilike.$startsWith%')
        .withConverter<List<Profile>>(_rowsToProfiles);
    return result!;
  }

  // TODO(caseycrogers): actually paginate this.
  Stream<Profile> getProfiles({
    required List<String> ids,
  }) async* {
    final result = await profilesQuery
        .select()
        .in_(idCol, ids)
        .withConverter<List<Profile>>(_rowsToProfiles);
    yield* Stream.fromIterable(result!);
  }

  List<Profile> _rowsToProfiles(dynamic rows) {
    return (rows as List<dynamic>)
        .map((dynamic row) => _rowToProfile(row)!)
        .toList();
  }

  Profile? _rowToProfile(dynamic row) {
    return Profile()
      ..mergeFromProto3Json(
        row as Map<String, dynamic>,
        ignoreUnknownFields: true,
      );
  }

  Future<Profile> getProfile({required String username}) async {
    return (await profilesQuery
        .select()
        .eq(usernameCol, username)
        .maybeSingle()
        .withConverter<Profile?>(_rowToProfile))!;
  }

  Future<Profile?> _fetchCurrentProfile() async {
    return await profilesQuery
        .select()
        .eq('id', supabase.auth.currentUser!.id)
        .maybeSingle()
        .withConverter<Profile?>(_rowToProfile);
  }

  // Wrap around any auth action to update Auth Manager state on finish.
  Future<void> _authActionWrapper(
    String action,
    AsyncCallback authAction,
  ) async {
    _isProcessing = true;
    notifyListeners();
    await authAction().then(
      (value) async {
        // Action was successful, clear last error.
        _authError = null;
        return value;
      },
      onError: (Object error, StackTrace stackTrace) {
        FirebaseCrashlytics.instance.recordError(error, stackTrace);
        log(
          'Auth action failed.',
          error: error,
          stackTrace: stackTrace,
        );
        _authError = error;
        throw error;
      },
    ).whenComplete(() {
      _isProcessing = false;
      notifyListeners();
    });
  }

  Future<void> _setAndListenForRegistrationToken() async {
    if (_hasRegisteredFcmToken || !isFullySignedIn) {
      return;
    }
    Future<void> _handleToken(String newToken) async {
      if (supabase.auth.currentUser == null) {
        return;
      }
      await fcmRegistrationTokensQuery.upsert({
        'id': supabase.auth.currentUser!.id,
        'registration_token': (await FirebaseMessaging.instance.getToken())!,
      });
    }

    FirebaseMessaging.instance.onTokenRefresh.listen(_handleToken);
    _hasRegisteredFcmToken = true;
    final String? initialToken = await FirebaseMessaging.instance.getToken();
    if (initialToken != null) {
      await _handleToken(initialToken);
    }
  }

  Future<void> googleSignIn() async {
    await _authActionWrapper(
      'signIn',
      () async {
        _signInState = SignInState.signingInThroughProvider;
        const redirectToUrl = 'com.cast.me.app://';
        final res = await supabase.auth.signInWithProvider(Provider.google,
            options: const AuthOptions(redirectTo: redirectToUrl));
        assert(res);
//        await _completeSignIn(false);
      },
    );
    Analytics.instance.logSignIn(user: supabase.auth.currentUser);
  }
}

enum SignInState {
  signingIn,
  registering,
  resettingPassword,
  settingNewPassword,
  verifyingEmail,
  completingProfile,
  signedIn,
  signingInThroughProvider,
}

extension SignInExtention on SignInState {}

extension CastMeUserUtils on CastMeProfileBase {
  bool get isComplete => displayName.isNotEmpty && profilePictureUrl.isNotEmpty;

  // The auth-specific user data.
  User get authUser => supabase.auth.currentUser!;

  Map<String, dynamic> toSQLJson() {
    return (toProto3Json() as Map<String, dynamic>).toSnakeCase();
  }
}

typedef Profile = CastMeProfileBase;

extension ProfileUtils on CastMeProfileBase {
  Color get accentColor =>
      ColorUtils.deserialize(accentColorBase.emptyToNull ?? 'FFFFFFFF');
}

class SignInBloc {
  SignInBloc._();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();
}
