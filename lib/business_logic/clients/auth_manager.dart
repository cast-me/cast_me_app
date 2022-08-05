import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cast_me_app/business_logic/clients/supabase_helpers.dart';
import 'package:cast_me_app/business_logic/models/protobufs/cast_me_profile_base.pb.dart';
import 'package:cast_me_app/util/disposable.dart';

import 'package:flutter/foundation.dart';

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
  CastMeSignInState? _signInState = CastMeSignInState.signingIn;

  CastMeSignInState get signInState => _signInState!;

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  bool _isSubmitting = false;

  // Whether or not we're submitting info and waiting for an async callback.
  // Submit buttons in sign up flow should be disabled while this is true.
  bool get isSubmitting => _isSubmitting;

  bool get isFullySignedIn => _signInState == CastMeSignInState.signedIn;

  Object? _authError;

  Object? get authError => _authError;

  void toggleAccountRegistrationFlow() {
    if (signInState == CastMeSignInState.registering) {
      _signInState = CastMeSignInState.signingIn;
    } else if (signInState == CastMeSignInState.signingIn) {
      _signInState = CastMeSignInState.registering;
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
    await Supabase.instance.client.auth
        .signUp(email, password)
        .checkAuthResult();
  }

  Future<void> completeUserProfile({
    required String displayName,
    required File profilePicture,
  }) async {
    await castMeProfiles
        .upsert(_castMeProfile!..displayName = displayName)
        .execute()
        .checkAuthResult();
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await Supabase.instance.client.auth
        .signIn(
          email: email,
          password: password,
        )
        .checkAuthResult();
  }

  CastMeProfile _docToCastMeProfile(PostgrestResponse<dynamic> doc) {
    if (doc.hasError) {
      throw Exception(doc.error);
    }
    return CastMeProfile.create()
      ..mergeFromProto3Json(doc.data() as Map<String, dynamic>);
  }

  void _init() {
    registerSubscription(
      SupabaseAuth.instance.onAuthChange
          .handleError((Object? error) => print(error))
          .listen(
        (AuthChangeEvent authEvent) {
          _onUserChanged();
        },
      ),
    );
  }

  Future<void> _onUserChanged() async {
    final User? user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      _castMeProfile = null;
    } else {
      _castMeProfile = _docToCastMeProfile(
        await Supabase.instance.client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .single()
            .execute(),
      );
    }
    _setSignInState();
    notifyListeners();
  }

  void _setSignInState() {
    if (_castMeProfile == null) {
      if (_signInState == CastMeSignInState.registering) {
        // Do nothing if we're already registering.
        return;
      }
      _signInState = CastMeSignInState.signingIn;
    } else if (!_castMeProfile!.isComplete) {
      _signInState = CastMeSignInState.completingProfile;
    } else {
      _signInState = CastMeSignInState.signedIn;
    }
  }

  // Exposed so that `AuthFutureUtil` can call it.
  void _notifyListeners() {
    notifyListeners();
  }
}

enum CastMeSignInState {
  signingIn,
  registering,
  completingProfile,
  signedIn,
}

extension SignInExtention on CastMeSignInState {}

extension CastMeUserUtils on CastMeProfileBase {
  bool get isComplete => displayName.isNotEmpty && profilePictureUri.isNotEmpty;

  // The auth-specific user data.
  User get authUser => Supabase.instance.client.auth.currentUser!;
}

extension AuthFutureUtil<T> on Future<T> {
  Future<T> checkAuthResult() {
    final AuthManager authManager = AuthManager.instance;
    authManager._isSubmitting = true;
    final Future<T> result = then(
      (value) {
        // Action was successful, clear last error.
        authManager._authError = null;
        authManager._isSubmitting = false;
        return value;
      },
      onError: (Object error, StackTrace stackTrace) {
        log(
          'Auth action failed.',
          error: error,
          stackTrace: stackTrace,
        );
        authManager._isSubmitting = false;
        authManager._authError = error;
        authManager._notifyListeners();
        throw error;
      },
    );
    // We need to let listeners know that we're now submitting.
    // We put this after calling then to ensure that even if it throws, then is
    // still executed.
    authManager._notifyListeners();
    return result;
  }
}

typedef CastMeProfile = CastMeProfileBase;
