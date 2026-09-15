import 'package:equatable/equatable.dart';

import 'package:movies_app/core/error/app_error_model.dart';

import 'package:movies_app/core/movies/domain/entities/movie_entity.dart';

class HomeCategory extends Equatable {
  const HomeCategory({required this.title, required this.movies});

  final String title;
  final List<MovieEntity> movies;

  @override
  List<Object?> get props => [title, movies];
}

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeSuccess extends HomeState {
  const HomeSuccess({required this.hero, required this.categories});

  final List<MovieEntity> hero;
  final List<HomeCategory> categories;

  @override
  List<Object?> get props => [hero, categories];
}

final class HomeEmpty extends HomeState {
  const HomeEmpty();
}

final class HomeError extends HomeState {
  const HomeError(this.error);

  final AppErrorModel error;

  @override
  List<Object?> get props => [error];
}
