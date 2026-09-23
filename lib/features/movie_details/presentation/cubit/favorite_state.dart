import 'package:equatable/equatable.dart';

import 'package:movies_app/core/error/app_error_model.dart';

sealed class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object?> get props => [];
}

final class FavoriteInitial extends FavoriteState {
  const FavoriteInitial();
}

final class FavoriteLoading extends FavoriteState {
  const FavoriteLoading();
}

final class FavoriteLoaded extends FavoriteState {
  const FavoriteLoaded(this.isFavorite);

  final bool isFavorite;

  @override
  List<Object?> get props => [isFavorite];
}

final class FavoriteError extends FavoriteState {
  const FavoriteError(this.error);

  final AppErrorModel error;

  @override
  List<Object?> get props => [error];
}
