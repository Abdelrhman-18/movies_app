import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:movies_app/core/services/firebase/firebase_execute.dart';
import 'package:movies_app/core/services/firebase/firestore_collections.dart';
import 'package:movies_app/core/services/firebase/firestore_service.dart';
import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/profile/data/models/user_model.dart';

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<AppResult<UserModel>> getCurrentUser() {
    return FirebaseExecute.call(() async {
      final firebaseUser = _auth.currentUser;

      if (firebaseUser == null) {
        throw Exception('No authenticated user found.');
      }

      UserModel? user;

      await for (final data
          in FirestoreService.instance.documentStream<UserModel>(
            path: '${FirestoreCollections.users}/${firebaseUser.uid}',
            builder: (data, documentId) {
              return UserModel.fromJson(data, documentId);
            },
          )) {
        user = data;
        break;
      }

      if (user == null) {
        throw Exception('User data not found.');
      }

      return user;
    });
  }

  Future<AppResult<void>> updateProfile({
    required String name,
    required String phone,
    int? avatarIndex,
    File? profileImage,
  }) {
    return FirebaseExecute.call(() async {
      final firebaseUser = _auth.currentUser;

      if (firebaseUser == null) {
        throw Exception('No authenticated user found.');
      }

      String? profileImageUrl;

      if (profileImage != null) {
        final reference = _storage
            .ref()
            .child('profile_images')
            .child('${firebaseUser.uid}.jpg');

        await reference.putFile(profileImage);

        profileImageUrl = await reference.getDownloadURL();
      }

      final Map<String, dynamic> data = {'name': name, 'phone': phone};

      if (profileImage != null) {
        data['avatarIndex'] = null;
        data['profileImageUrl'] = profileImageUrl;
      } else if (avatarIndex != null) {
        data['avatarIndex'] = avatarIndex;
        data['profileImageUrl'] = null;
      }

      await FirestoreService.instance.setData(
        path: '${FirestoreCollections.users}/${firebaseUser.uid}',
        data: data,
        merge: true,
      );
    });
  }

  Future<AppResult<void>> deleteAccount() {
    return FirebaseExecute.call(() async {
      final firebaseUser = _auth.currentUser;

      if (firebaseUser == null) {
        throw Exception('No authenticated user found.');
      }

      final userDocPath = '${FirestoreCollections.users}/${firebaseUser.uid}';

      Map<String, dynamic>? userData;
      await for (final data
          in FirestoreService.instance.documentStream<Map<String, dynamic>>(
            path: userDocPath,
            builder: (data, _) => data,
          )) {
        userData = data;
        break;
      }

      await FirestoreService.instance.deleteData(path: userDocPath);

      try {
        await firebaseUser.delete();
      } catch (_) {
        if (userData != null) {
          await FirestoreService.instance.setData(
            path: userDocPath,
            data: userData,
          );
        }
        rethrow;
      }
    });
  }
}
