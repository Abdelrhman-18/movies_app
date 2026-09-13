import 'package:movies_app/features/auth/data/models/user_model.dart';

sealed class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileUserLoaded extends ProfileState {
  ProfileUserLoaded(this.user);

  final UserModel user;
}

class ProfileSuccess extends ProfileState {}

class ProfileError extends ProfileState {
  ProfileError(this.message);

  final String message;
}