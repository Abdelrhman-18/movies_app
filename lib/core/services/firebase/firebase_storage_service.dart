import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  FirebaseStorageService._();

  static final FirebaseStorageService instance =
  FirebaseStorageService._();

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadProfileImage({
    required String userId,
    required File image,
  }) async {
    final reference = _storage
        .ref()
        .child('users')
        .child(userId)
        .child('profile_image.jpg');

    await reference.putFile(image);

    return await reference.getDownloadURL();
  }
}