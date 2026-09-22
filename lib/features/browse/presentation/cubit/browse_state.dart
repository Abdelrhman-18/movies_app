import 'package:equatable/equatable.dart';

import 'package:movies_app/core/error/app_error_model.dart';
import 'package:movies_app/features/home/domain/entities/movie_entity.dart';

sealed class BrowseState extends Equatable {
  const BrowseState({required this.genres, required this.selectedGenre});

  final Set<String> genres;
  final String? selectedGenre;

  @override
  List<Object?> get props => [genres, selectedGenre];
}

final class BrowseLoading extends BrowseState {
  const BrowseLoading({super.genres = const {}, super.selectedGenre});
}

final class BrowseSuccess extends BrowseState {
  const BrowseSuccess({
    required super.genres,
    required super.selectedGenre,
    required this.movies,
  });

  final List<MovieEntity> movies;

  @override
  List<Object?> get props => [genres, selectedGenre, movies];
}

final class BrowseEmpty extends BrowseState {
  const BrowseEmpty({required super.genres, required super.selectedGenre});
}

final class BrowseError extends BrowseState {
  const BrowseError({
    required super.genres,
    required super.selectedGenre,
    required this.error,
  });

  final AppErrorModel error;

  @override
  List<Object?> get props => [genres, selectedGenre, error];
}