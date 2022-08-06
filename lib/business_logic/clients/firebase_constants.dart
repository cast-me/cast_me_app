import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

const castsString = 'casts';

const String usersString = 'users';

const String profilePictureString = 'user_profile_pictures';

const String gsPrefix = 'gs://cast-me-app.appspot.com';

final CollectionReference usersCollection =
    FirebaseFirestore.instance.collection(usersString);

final CollectionReference castsCollection =
    FirebaseFirestore.instance.collection(castsString);

final Reference usersReference = FirebaseStorage.instance.ref(usersString);

final Reference castsReference = FirebaseStorage.instance.ref(castsString);

final Reference profilePicturesReference =
    FirebaseStorage.instance.ref(profilePictureString);

extension RefUtils on Reference {
  String get gsUrl => join(gsPrefix, fullPath);
}
