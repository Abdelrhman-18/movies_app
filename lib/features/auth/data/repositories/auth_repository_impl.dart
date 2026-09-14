import 'dart:io';

import 'package:movies_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:movies_app/features/auth/domain/entities/user.dart';
import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<User> getCurrentUser() async {
    final userModel = await _remoteDataSource.getCurrentUser();

    return userModel.toEntity();
  }

  @override
  Future<void> updateProfile({
    required String name,
    required String phone,
    int? avatarIndex,
    File? profileImage,
  }) async {
    await _remoteDataSource.updateProfile(
      name: name,
      phone: phone,
      avatarIndex: avatarIndex,
      profileImage: profileImage,
    );
  }
}