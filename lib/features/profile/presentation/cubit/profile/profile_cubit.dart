import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/profile/domain/repos/profile_repository.dart';
import 'package:movies_app/features/profile/presentation/cubit/profile/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._profileRepository) : super(const ProfileInitial());

  final ProfileRepository _profileRepository;

  Future<void> getCurrentUser() async {
    emit(const ProfileLoading());

    final result = await _profileRepository.getCurrentUser();

    emit(switch (result) {
      Success(data: final user) => ProfileUserLoaded(user),
      Failure(error: final error) => ProfileError(error.message ?? error.code),
    });
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    int? avatarIndex,
    File? profileImage,
  }) async {
    emit(const ProfileLoading());

    final result = await _profileRepository.updateProfile(
      name: name,
      phone: phone,
      avatarIndex: avatarIndex,
      profileImage: profileImage,
    );

    emit(switch (result) {
      Success() => const ProfileSuccess(),
      Failure(error: final error) => ProfileError(error.message ?? error.code),
    });
  }

  Future<void> deleteAccount() async {
    emit(const ProfileLoading());

    final result = await _profileRepository.deleteAccount();

    emit(switch (result) {
      Success() => const ProfileAccountDeleted(),
      Failure(error: final error) when error.code == _requiresRecentLogin =>
        const ProfileReauthRequired(),
      Failure(error: final error) => ProfileError(error.message ?? error.code),
    });
  }

  static const String _requiresRecentLogin = 'requires-recent-login';
}
