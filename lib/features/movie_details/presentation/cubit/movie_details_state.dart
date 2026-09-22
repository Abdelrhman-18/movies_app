import 'package:equatable/equatable.dart';

import 'package:movies_app/core/error/app_error_model.dart';

import 'package:movies_app/features/movie_details/domain/entities/movie_details_entity.dart';
import 'package:movies_app/features/movie_details/domain/entities/related_movie_entity.dart';

sealed class MovieDetailsState extends Equatable {
  const MovieDetailsState();

  @override
  List<Object?> get props => [];
}

final class MovieDetailsLoading extends MovieDetailsState {
  const MovieDetailsLoading();
}

final class MovieDetailsSuccess extends MovieDetailsState {
  const MovieDetailsSuccess({required this.details, required this.suggestions});

  final MovieDetailsEntity details;
  final List<RelatedMovieEntity> suggestions;

  @override
  List<Object?> get props => [details, suggestions];
}

final class MovieDetailsError extends MovieDetailsState {
  const MovieDetailsError(this.error);

  final AppErrorModel error;

  @override
  List<Object?> get props => [error];
}
