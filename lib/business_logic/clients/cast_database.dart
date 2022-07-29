import 'package:cast_me_app/business_logic/models/cast.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CastDatabase {
  CastDatabase._();

  static final CastDatabase instance = CastDatabase._();

  static final _db = FirebaseFirestore.instance;

  Stream<Cast> getCasts() async* {
    DocumentSnapshot? lastDoc;
    while (true) {
      final List<DocumentSnapshot> docs = (await _db
          .collection(castsCollection)
          .limit(20)
          .startAt([lastDoc]).get()).docs;
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
  return Cast.fromJson(doc.data().toString());
}

const castsCollection = 'casts';
