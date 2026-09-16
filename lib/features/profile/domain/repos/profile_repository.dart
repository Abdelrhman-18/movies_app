import 'dart:io';

import 'package:movies_app/core/utils/app_result.dart';
import 'package:movies_app/features/profile/domain/entities/user.dart';

abstract interface class ProfileRepository {
  Future<AppResult<User>> getCurrentUser();

  Future<AppResult<void>> updateProfile({
    required String name,
    required String phone,
    int? avatarIndex,
    File? profileImage,
  });
}
