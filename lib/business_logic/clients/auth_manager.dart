import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
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
class AuthManager extends ChangeNotifier {
  AuthManager._() {
    supabase.auth.onAuthStateChange((event, session) {
      if (_signInState == SignInState.verifyingEmail &&
          event == AuthChangeEvent.signedIn) {
        // Edge case to catch when the user has externally verified
        // their email.
        _signInState = SignInState.completingProfile;
        notifyListeners();
      }
    });
  }

  static final AuthManager instance = AuthManager._();

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

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  void toggleAccountRegistrationFlow() {
    if (signInState == SignInState.registering) {
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
          await supabase.auth.signUp(email, password).errorToException();
        } on GoTrueException catch (e) {
          // Hack to catch an erroneous error.
          // TODO(caseycrogers): remove this catch once the issue is resolved:
          // https://github.com/supabase-community/supabase-flutter/issues/182
          if (e.statusCode != null) {
            rethrow;
          }
        }
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
        if (emailNotConfirmed) {
          _signInState = SignInState.verifyingEmail;
          return;
        }
        _profile = await _fetchProfile();
        if (_profile == null) {
          _signInState = SignInState.completingProfile;
        } else {
          await _setRegistrationToken();
          _signInState = SignInState.signedIn;
        }
      },
    );
  }

  void exitEmailVerification() {
    _signInState = SignInState.registering;
    notifyListeners();
  }

  Future<void> signOut({bool returnToRegistering = false}) async {
    await _authActionWrapper(
      'signOut',
      () async {
        await supabase.auth.signOut().errorToException();
        _profile = null;
        if (returnToRegistering) {
          _signInState = SignInState.registering;
        } else {
          _signInState = SignInState.signingIn;
        }
      },
    );
    // Also reset the current tab so that the user goes back to home if they log
    // back in.
    CastMeBloc.instance.onTabChanged(CastMeTab.listen);
  }

  Future<void> initialize() async {
    final User? user = supabase.auth.currentUser;
    if (user == null) {
      _profile = null;
      _signInState = SignInState.signingIn;
    } else {
      _profile = await _fetchProfile();
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

  Profile? _rowToCastMeProfile(dynamic rows) {
    final List<dynamic> rowList = rows as List<dynamic>;
    if (rowList.isEmpty) {
      return null;
    }
    return Profile()
      ..mergeFromProto3Json(rowList.single as Map<String, dynamic>);
  }

  Future<Profile?> _fetchProfile() async {
    return await supabase
        .from('profiles')
        .select()
        .eq('id', supabase.auth.currentUser!.id)
        .withConverter<Profile?>(_rowToCastMeProfile);
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

  Future<void> _setRegistrationToken() async {
    await fcmRegistrationTokensQuery.upsert({
      'id': supabase.auth.currentUser!.id,
      'registration_token': (await FirebaseMessaging.instance.getToken())!,
    });
  }
}

enum SignInState {
  signingIn,
  registering,
  verifyingEmail,
  completingProfile,
  signedIn,
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
