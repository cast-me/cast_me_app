import 'dart:convert';

import 'package:cast_me_app/business_logic/models/cast.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CastDatabase {
  CastDatabase._();

  static final CastDatabase instance = CastDatabase._();

  static final _db = FirebaseFirestore.instance;

  Stream<Cast> getCasts() async* {
    DocumentSnapshot? lastDoc;
    while (true) {
      Query query = _db
          .collection(castsCollection)
          .orderBy(FieldPath.documentId)
          .limit(20);
      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }
      final List<DocumentSnapshot> docs = (await query.get()).docs;
      if (docs.isEmpty) {
        return;
      }
      lastDoc = docs.last;
      for (DocumentSnapshot doc in docs) {
        yield docToCast(doc);
      }
    }
  }
}

Cast docToCast(DocumentSnapshot doc) {
  return Cast.create()..mergeFromProto3Json(doc.data() as Map<String, dynamic>);
}

const castsCollection = 'casts';
