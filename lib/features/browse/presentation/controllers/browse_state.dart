import 'package:equatable/equatable.dart';

import 'package:movies_app/core/error/app_error_model.dart';

import 'package:movies_app/core/movies/domain/entities/movie_entity.dart';

sealed class BrowseState extends Equatable {
  const BrowseState(this.genre);

  final String genre;

  @override
  List<Object?> get props => [genre];
}

final class BrowseLoading extends BrowseState {
  const BrowseLoading(super.genre);
}

final class BrowseSuccess extends BrowseState {
  const BrowseSuccess(super.genre, this.movies);

  final List<MovieEntity> movies;

  @override
  List<Object?> get props => [genre, movies];
}

final class BrowseEmpty extends BrowseState {
  const BrowseEmpty(super.genre);
}

final class BrowseError extends BrowseState {
  const BrowseError(super.genre, this.error);

  final AppErrorModel error;

  @override
  List<Object?> get props => [genre, error];
}
