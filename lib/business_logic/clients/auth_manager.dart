import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cast_me_app/business_logic/clients/firebase_constants.dart';
import 'package:cast_me_app/business_logic/models/protobufs/cast_me_user_base.pb.dart';
import 'package:cast_me_app/util/disposable.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/foundation.dart';

import 'package:rxdart/rxdart.dart';

/// Notifies when the Firebase auth state changes or the CastMe user changes.
class AuthManager extends ChangeNotifier with Disposable {
  AuthManager._() {
    _init();
  }

  static final AuthManager instance = AuthManager._();

  CastMeUser? _castMeUser;

  CastMeUser? get castMeUser => _castMeUser;

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

  Exception? _authError;

  Exception? get authError => _authError;

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
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
        .checkAuthResult();
  }

  Future<void> setDisplayName(String displayName) async {
    await FirebaseFirestore.instance
        .collection(usersString)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set((_castMeUser!..displayName = displayName).toProto3Json()
            as Map<String, dynamic>)
        .checkAuthResult();
  }

  Future<void> setUserPhoto(File file) async {
    final TaskSnapshot task = await usersReference
        .child(file.uri.pathSegments.last)
        .putFile(file)
        .checkAuthResult();
    await usersCollection
        .doc(_castMeUser!.uid)
        .set((_castMeUser!..profilePictureUri = task.ref.gsUri).toProto3Json()
            as Map<String, dynamic>)
        .checkAuthResult();
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
        .checkAuthResult();
  }

  CastMeUser _docToCastMeUser(DocumentSnapshot doc) {
    return CastMeUserBase.create()
      ..mergeFromProto3Json(doc.data() as Map<String, dynamic>);
  }

  void _init() {
    registerSubscription(
      FirebaseAuth.instance
          .authStateChanges()
          .handleError((Object? error) => print(error))
          .flatMap((authUser) {
        // Update is loading after the first auth event.
        _isLoading = false;
        if (authUser == null) {
          return Stream.value(null);
        }
        return FirebaseFirestore.instance
            .collection(usersString)
            .doc(authUser.uid)
            .snapshots()
            .map((doc) {
          if (doc.data() == null) {
            return CastMeUserBase(uid: authUser.uid);
          }
          return _docToCastMeUser(doc);
        });
      }).listen(_onUserChanged),
    );
  }

  void _onUserChanged(CastMeUser? newUser) {
    _castMeUser = newUser;
    _setSignInState();
    notifyListeners();
  }

  void _setSignInState() {
    if (_castMeUser == null) {
      if (_signInState == CastMeSignInState.registering) {
        // Do nothing if we're already registering.
        return;
      }
      _signInState = CastMeSignInState.signingIn;
    } else if (!_castMeUser!.isComplete) {
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

extension CastMeUserUtils on CastMeUserBase {
  bool get isComplete => displayName.isNotEmpty && profilePictureUri.isNotEmpty;

  // The auth-specific user data.
  User get authUser => FirebaseAuth.instance.currentUser!;
}

extension AuthFutureUtil<T> on Future<T> {
  Future<T> checkAuthResult() {
    final AuthManager authManager = AuthManager.instance;
    authManager._isSubmitting = true;
    // We need to let listeners know that we're now submitting.
    authManager._notifyListeners();
    return then(
      (value) {
        // Action was successful, clear last error.
        authManager._authError = null;
        authManager._isSubmitting = false;
        return value;
      },
      onError: (Exception error, StackTrace stackTrace) {
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
  }
}

typedef CastMeUser = CastMeUserBase;
