import 'dart:io';
import 'dart:typed_data';

import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/firebase_constants.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/util/color_utils.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class CastDatabase {
  CastDatabase._();

  static final CastDatabase instance = CastDatabase._();

  static final _db = FirebaseFirestore.instance;

  Stream<Cast> getCasts() async* {
    DocumentSnapshot? lastDoc;
    while (true) {
      Query query =
          _db.collection(castsString).orderBy(FieldPath.documentId).limit(20);
      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }
      final List<DocumentSnapshot> docs = (await query.get()).docs;
      if (docs.isEmpty) {
        return;
      }
      lastDoc = docs.last;
      for (final DocumentSnapshot doc in docs) {
        yield docToCast(doc);
      }
    }
  }

  Future<void> createCast({
    required String title,
    required File file,
  }) async {
    final TaskSnapshot castUpload =
        await castsReference.child(file.uri.pathSegments.last).putFile(file);
    final CastMeProfile user = AuthManager.instance.castMeProfile!;
    final Uint8List imageBytes = (await FirebaseStorage.instance
        .refFromURL(user.profilePictureUri)
        .getData())!;
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(MemoryImage(imageBytes));
    final Cast cast = Cast(
      authorId: user.id,
      authorDisplayName: user.displayName,
      title: title,
      durationMs: 60000,
      audioUriBase: castUpload.ref.gsUri,
      imageUriBase: user.profilePictureUri,
      accentColorBase: paletteGenerator.vibrantColor!.color.serialize,
    );
    await castsCollection.add(cast.toProto3Json());
  }
}

Cast docToCast(DocumentSnapshot doc) {
  return Cast.create()..mergeFromProto3Json(doc.data() as Map<String, dynamic>);
}
