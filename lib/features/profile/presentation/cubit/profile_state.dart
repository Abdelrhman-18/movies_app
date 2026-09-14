import 'package:movies_app/features/auth/domain/entities/user.dart';

sealed class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileUserLoaded extends ProfileState {
  ProfileUserLoaded(this.user);

  final User user;
}

class ProfileSuccess extends ProfileState {}

class ProfileError extends ProfileState {
  ProfileError(this.message);

  final String message;
}