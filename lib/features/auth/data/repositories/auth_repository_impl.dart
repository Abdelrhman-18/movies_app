import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:movies_app/features/auth/data/models/user_model.dart';
import 'package:movies_app/features/auth/data/repositories/auth_repository.dart';

import 'package:movies_app/core/services/firebase/firebase_execute.dart';
import 'package:movies_app/core/services/firebase/firestore_service.dart';
import 'package:movies_app/core/services/firebase/firebase_storage_service.dart';

import '../../../../core/services/firebase/firestore_collections.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    FirebaseAuth? firebaseAuth,
    FirestoreService? firestoreService,
    FirebaseStorageService? storageService,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestoreService =
            firestoreService ?? FirestoreService.instance,
        _storageService =
            storageService ?? FirebaseStorageService.instance;

  final FirebaseAuth _firebaseAuth;
  final FirestoreService _firestoreService;
  final FirebaseStorageService _storageService;

  @override
  Future<UserModel> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;

    if (firebaseUser == null) {
      throw Exception('No user is currently signed in.');
    }

    final user = await _firestoreService.documentStream<UserModel>(
      path: '${FirestoreCollections.users}/${firebaseUser.uid}',
      builder: (data, documentId) {
        return UserModel.fromJson(data, documentId);
      },
    ).first;

    if (user == null) {
      throw Exception('User profile not found.');
    }

    return user;
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
      throw Exception('No user is currently signed in.');
    }

    final Map<String, dynamic> data = {
      'name': name,
      'phone': phone,
    };

    // User selected a new gallery image.
    if (profileImage != null) {
      final profileImageUrl =
      await _storageService.uploadProfileImage(
        userId: firebaseUser.uid,
        image: profileImage,
      );

      data['avatarIndex'] = null;
      data['profileImageUrl'] = profileImageUrl;
    }
    // User selected a preset avatar.
    else if (avatarIndex != null) {
      data['avatarIndex'] = avatarIndex;
      data['profileImageUrl'] = null;
    }

    await _firestoreService.setData(
      path: '${FirestoreCollections.users}/${firebaseUser.uid}',
      data: data,
      merge: true,
    );
  }
}