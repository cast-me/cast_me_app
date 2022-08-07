import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cast_me_app/business_logic/clients/supabase_helpers.dart';
import 'package:cast_me_app/business_logic/models/protobufs/cast_me_profile_base.pb.dart';
import 'package:cast_me_app/util/color_utils.dart';
import 'package:cast_me_app/util/disposable.dart';
import 'package:cast_me_app/util/string_utils.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Notifies when the Firebase auth state changes or the CastMe user changes.
class AuthManager extends ChangeNotifier with Disposable {
  AuthManager._() {
    _init();
  }

  static final AuthManager instance = AuthManager._();

  CastMeProfile? _castMeProfile;

  CastMeProfile? get castMeProfile => _castMeProfile;

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
      () async {
        await supabase.auth.signUp(email, password).errorToException();
        _signInState = SignInState.verifyingEmail;
      },
    );
  }

  Future<void> checkEmailIsVerified({
    required String email,
    required String password,
  }) async {
    await _authActionWrapper(() async {
      await supabase.auth
          .signIn(
            email: email,
            password: password,
          )
          .errorToException();
      _signInState = SignInState.completingProfile;
    });
  }

  Future<void> completeUserProfile({
    required String username,
    required String displayName,
    required File profilePicture,
  }) async {
    await _authActionWrapper(
      () async {
        final String fileExt = profilePicture.path.split('.').last;
        // Anonymize the file name so we don't get naming conflicts.
        final String fileName = '${DateTime.now().toIso8601String()}.$fileExt';
        final Uint8List imageBytes = await profilePicture.readAsBytes();
        await profilePicturesBucket
            .uploadBinary(fileName, imageBytes)
            .errorToException();
        final String profilePictureUrl = profilePicturesBucket
            .getPublicUrl(fileName)
            .errorToException()
            .data as String;
        final PaletteGenerator paletteGenerator =
            await PaletteGenerator.fromImageProvider(MemoryImage(imageBytes));
        final CastMeProfile completedProfile = CastMeProfile(
          id: supabase.auth.currentUser!.id,
          username: username,
          displayName: displayName,
          profilePictureUrl: profilePictureUrl,
          accentColorBase: paletteGenerator.vibrantColor!.color.serialize,
        );
        await profilesQuery
            .upsert(completedProfile.toSQLJson())
            .execute()
            .errorToException();
        _castMeProfile = completedProfile;
        _signInState = SignInState.signedIn;
      },
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _authActionWrapper(
      () async {
        await supabase.auth
            .signIn(
              email: email,
              password: password,
            )
            .errorToException();
        _castMeProfile = await _fetchProfile();
        if (_castMeProfile == null) {
          _signInState = SignInState.completingProfile;
        } else {
          _signInState = SignInState.signedIn;
        }
      },
    );
  }

  CastMeProfile? _docToCastMeProfile(PostgrestResponse<dynamic> doc) {
    if (doc.hasError) {
      throw Exception(doc.error);
    }
    if (doc.count == 0) {
      return null;
    }
    return CastMeProfile()
      ..mergeFromProto3Json(doc.data as Map<String, dynamic>);
  }

  Future<void> _init() async {
    supabase.auth.onAuthStateChange((event, session) {
      print('----------------------------');
      print(event);
      print(session);
    });
    final User? user = supabase.auth.currentUser;
    if (user == null) {
      _castMeProfile = null;
      _signInState = SignInState.signingIn;
    } else {
      _castMeProfile = await _fetchProfile();
      if (user.emailConfirmedAt == null) {
        _signInState = SignInState.verifyingEmail;
      } else if (_castMeProfile == null) {
        _signInState = SignInState.completingProfile;
      } else {
        _signInState = SignInState.signedIn;
      }
    }
    _isInitialized = true;
    notifyListeners();
  }

  Future<CastMeProfile?> _fetchProfile() async {
    return _docToCastMeProfile(
      await supabase
          .from('profiles')
          .select()
          .eq('id', supabase.auth.currentUser!.id)
          .maybeSingle()
          .execute(),
    );
  }

  // Exposed so that `AuthFutureUtil` can call it.
  void _notifyListeners() {
    notifyListeners();
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

// Wrap around any auth action to update Auth Manager state on error or success.
Future<void> _authActionWrapper(AsyncCallback authAction) async {
  final AuthManager authManager = AuthManager.instance;
  authManager._isProcessing = true;
  authManager._notifyListeners();
  await authAction().then(
    (value) async {
      // Action was successful, clear last error.
      authManager._authError = null;
      return value;
    },
    onError: (Object error, StackTrace stackTrace) {
      log(
        'Auth action failed.',
        error: error,
        stackTrace: stackTrace,
      );
      authManager._authError = error;
      throw error;
    },
  ).whenComplete(() {
    authManager._isProcessing = false;
    authManager._notifyListeners();
  });
}

typedef CastMeProfile = CastMeProfileBase;
