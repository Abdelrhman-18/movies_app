import 'dart:io';

import 'package:movies_app/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> getCurrentUser();

  Future<void> updateProfile({
    required String name,
    required String phone,
    int? avatarIndex,
    File? profileImage,
  });
}