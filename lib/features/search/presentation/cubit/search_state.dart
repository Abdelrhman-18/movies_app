import 'package:equatable/equatable.dart';

import 'package:movies_app/core/error/app_error_model.dart';
import 'package:movies_app/features/home/domain/entities/movie_entity.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

final class SearchInitial extends SearchState {
  const SearchInitial();
}

final class SearchLoading extends SearchState {
  const SearchLoading();
}

final class SearchSuccess extends SearchState {
  const SearchSuccess(this.movies);

  final List<MovieEntity> movies;

  @override
  List<Object?> get props => [movies];
}

final class SearchEmpty extends SearchState {
  const SearchEmpty();
}

final class SearchError extends SearchState {
  const SearchError(this.error);

  final AppErrorModel error;

  @override
  List<Object?> get props => [error];
}
