import 'package:equatable/equatable.dart';

import 'package:movies_app/features/profile/domain/entities/user.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileUserLoaded extends ProfileState {
  const ProfileUserLoaded(this.user);

  final User user;

  @override
  List<Object?> get props => [user];
}

final class ProfileSuccess extends ProfileState {
  const ProfileSuccess();
}

final class ProfileAccountDeleted extends ProfileState {
  const ProfileAccountDeleted();
}

final class ProfileReauthRequired extends ProfileState {
  const ProfileReauthRequired();
}

final class ProfileError extends ProfileState {
  const ProfileError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
