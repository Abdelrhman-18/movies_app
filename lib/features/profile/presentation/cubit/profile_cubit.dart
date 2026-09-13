import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/features/auth/data/models/user_model.dart';
import 'package:movies_app/features/auth/data/repositories/auth_repository.dart';
import 'package:movies_app/features/profile/presentation/cubit/profile_state.dart';


class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._authRepository) : super(ProfileInitial());

  final AuthRepository _authRepository;

  Future<void> getCurrentUser() async {
    emit(ProfileLoading());

    try {
      final user = await _authRepository.getCurrentUser();

      emit(ProfileUserLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    int? avatarIndex,
    File? profileImage,
  }) async {
    emit(ProfileLoading());

    try {
      await _authRepository.updateProfile(
        name: name,
        phone: phone,
        avatarIndex: avatarIndex,
        profileImage: profileImage,
      );

      emit(ProfileSuccess());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}