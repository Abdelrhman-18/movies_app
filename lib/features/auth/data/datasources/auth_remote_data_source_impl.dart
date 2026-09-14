import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:movies_app/core/services/firebase/firebase_execute.dart';
import 'package:movies_app/core/services/firebase/firestore_collections.dart';
import 'package:movies_app/core/services/firebase/firestore_service.dart';
import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:movies_app/features/auth/data/models/user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseStorage _firebaseStorage;
  final FirestoreService _firestoreService;

  AuthRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseStorage? firebaseStorage,
    FirestoreService? firestoreService,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance,
        _firestoreService = firestoreService ?? FirestoreService.instance;

  @override
  Future<UserModel> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;

    if (firebaseUser == null) {
      throw Exception('No authenticated user found.');
    }

    final result = await FirebaseExecute.call<UserModel>(() async {
      UserModel? user;

      await for (final data
      in _firestoreService.documentStream<UserModel>(
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

    switch (result) {
      case Success<UserModel>():
        return result.data;

      case Failure<UserModel>():
        throw Exception(result.error.message);
    }
  }

  @override
  Future<void> updateProfile({
    required String name,
    required String phone,
    int? avatarIndex,
    File? profileImage,
  }) async {
    final firebaseUser = _firebaseAuth.currentUser;

    if (firebaseUser == null) {
      throw Exception('No authenticated user found.');
    }

    final result = await FirebaseExecute.call<void>(() async {
      String? profileImageUrl;

      // لو المستخدم اختار صورة من Gallery
      if (profileImage != null) {
        final reference = _firebaseStorage
            .ref()
            .child('profile_images')
            .child('${firebaseUser.uid}.jpg');

        await reference.putFile(profileImage);

        profileImageUrl = await reference.getDownloadURL();
      }

      final Map<String, dynamic> data = {
        'name': name,
        'phone': phone,
      };

      if (profileImage != null) {
        data['avatarIndex'] = null;
        data['profileImageUrl'] = profileImageUrl;
      }

      else if (avatarIndex != null) {
        data['avatarIndex'] = avatarIndex;
        data['profileImageUrl'] = null;
      }

      await _firestoreService.setData(
        path: '${FirestoreCollections.users}/${firebaseUser.uid}',
        data: data,
        merge: true,
      );
    });

    switch (result) {
      case Success<void>():
        return;

      case Failure<void>():
        throw Exception(result.error.message);
    }
  }
  @override
  Future<void> resetPassword(String email) async {
    final result = await FirebaseExecute.call<void>(
          () => _firebaseAuth.sendPasswordResetEmail(
        email: email,
      ),
    );

    switch (result) {
      case Success<void>():
        return;

      case Failure<void>():
        throw Exception(result.error.message);
    }
  }
}