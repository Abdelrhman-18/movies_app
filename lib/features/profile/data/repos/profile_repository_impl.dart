import 'dart:io';

import 'package:movies_app/core/utils/app_result.dart';
import 'package:movies_app/features/profile/data/datasources/profile_service.dart';
import 'package:movies_app/features/profile/domain/entities/user.dart';
import 'package:movies_app/features/profile/domain/repos/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._profileService);

  final ProfileService _profileService;

  @override
  Future<AppResult<User>> getCurrentUser() async {
    final result = await _profileService.getCurrentUser();

    return switch (result) {
      Success(data: final userModel) => Success(userModel.toEntity()),
      Failure(error: final error) => Failure(error),
    };
  }

  @override
  Future<AppResult<void>> updateProfile({
    required String name,
    required String phone,
    int? avatarIndex,
    File? profileImage,
  }) {
    return _profileService.updateProfile(
      name: name,
      phone: phone,
      avatarIndex: avatarIndex,
      profileImage: profileImage,
    );
  }
}
