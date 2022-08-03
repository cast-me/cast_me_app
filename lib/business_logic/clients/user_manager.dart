import 'dart:convert';
import 'dart:io';

import 'package:cast_me_app/business_logic/models/protobufs/cast_me_user_base.pb.dart';
import 'package:cast_me_app/util/stream_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';

class UserManager {
  UserManager._();

  static const String _usersString = 'users';

  static const String _profilePictureString = 'user_profile_pictures';

  static const String _gsPrefix = 'gs://cast-me-app.appspot.com';

  static final UserManager instance = UserManager._();

  late final ValueListenable<CastMeUser?> currentUser =
      FirebaseAuth.instance.authStateChanges().flatMap((authUser) {
    if (authUser == null) {
      return Stream.value(null);
    }
    return FirebaseFirestore.instance
        .collection(_usersString)
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
        .collection(_usersString)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set((currentUser.value!..displayName = displayName).toProto3Json()
            as Map<String, dynamic>);
  }

  Future<String?> setUserPhoto(File file) async {
    final TaskSnapshot task = await FirebaseStorage.instance
        .ref('/$_profilePictureString/${file.uri.pathSegments.last}')
        .putFile(file);
    FirebaseFirestore.instance
        .collection(_usersString)
        .doc(currentUser.value!.uid)
        .set((currentUser.value!
              ..profilePictureUri = join(_gsPrefix, task.ref.fullPath))
            .toProto3Json() as Map<String, dynamic>);
  }
}

extension CastMeUserUtils on CastMeUserBase {
  bool get isComplete => displayName.isNotEmpty && profilePictureUri.isNotEmpty;
}

typedef CastMeUser = CastMeUserBase;
