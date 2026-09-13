import 'dart:io';

import 'package:movies_app/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> getCurrentUser();

  Future<void> updateProfile({
    required String name,
    required String phone,
    int? avatarIndex,
    File? profileImage,
  });
}