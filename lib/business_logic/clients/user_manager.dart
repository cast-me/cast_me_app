import 'dart:io';

import 'package:cast_me_app/business_logic/clients/firebase_constants.dart';
import 'package:cast_me_app/business_logic/models/protobufs/cast_me_user_base.pb.dart';
import 'package:cast_me_app/util/stream_utils.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/foundation.dart';

import 'package:rxdart/rxdart.dart';

class UserManager {
  UserManager._();

  static final UserManager instance = UserManager._();

  late final ValueListenable<CastMeUser?> currentUser =
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
      return docToCastMeUser(doc);
    });
  }).toListenable();

  CastMeUser docToCastMeUser(DocumentSnapshot doc) {
    return CastMeUserBase.create()
      ..mergeFromProto3Json(doc.data() as Map<String, dynamic>);
  }

  Future<void> setDisplayName(String displayName) async {
    await FirebaseFirestore.instance
        .collection(usersString)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set((currentUser.value!..displayName = displayName).toProto3Json()
            as Map<String, dynamic>);
  }

  Future<void> setUserPhoto(File file) async {
    final TaskSnapshot task =
        await usersReference.child(file.uri.pathSegments.last).putFile(file);
    await usersCollection.doc(currentUser.value!.uid).set(
        (currentUser.value!..profilePictureUri = task.ref.gsUri).toProto3Json()
            as Map<String, dynamic>);
  }
}

extension CastMeUserUtils on CastMeUserBase {
  bool get isComplete => displayName.isNotEmpty && profilePictureUri.isNotEmpty;
}

typedef CastMeUser = CastMeUserBase;
