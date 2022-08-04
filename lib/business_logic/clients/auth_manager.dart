import 'dart:async';
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
  late CastMeSignInState _signInState;

  CastMeSignInState? get signInState => _signInState;

  bool get isLoading => _castMeUser == null;

  bool get isFullySignedIn => _signInState == CastMeSignInState.signedIn;

  Future<void> setDisplayName(String displayName) async {
    await FirebaseFirestore.instance
        .collection(usersString)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set((_castMeUser!..displayName = displayName).toProto3Json()
            as Map<String, dynamic>);
  }

  Future<void> setUserPhoto(File file) async {
    final TaskSnapshot task =
        await usersReference.child(file.uri.pathSegments.last).putFile(file);
    await usersCollection.doc(_castMeUser!.uid).set(
        (_castMeUser!..profilePictureUri = task.ref.gsUri).toProto3Json()
            as Map<String, dynamic>);
  }

  CastMeUser _docToCastMeUser(DocumentSnapshot doc) {
    return CastMeUserBase.create()
      ..mergeFromProto3Json(doc.data() as Map<String, dynamic>);
  }

  void _init() {
    registerSubscription(
      FirebaseAuth.instance.authStateChanges().flatMap((authUser) {
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
      _signInState = CastMeSignInState.signedOut;
    } else if (!_castMeUser!.isComplete) {
      _signInState = CastMeSignInState.completingProfile;
    } else {
      _signInState = CastMeSignInState.signedIn;
    }
  }
}

enum CastMeSignInState {
  signedOut,
  completingProfile,
  signedIn,
}

extension CastMeUserUtils on CastMeUserBase {
  bool get isComplete => displayName.isNotEmpty && profilePictureUri.isNotEmpty;

  // The auth-specific user data.
  User get authUser => FirebaseAuth.instance.currentUser!;
}

typedef CastMeUser = CastMeUserBase;
