import 'package:movies_app/core/error/app_error_model.dart';
import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/movie_details/data/datasources/movie_details_remote_data_source.dart';
import 'package:movies_app/features/movie_details/domain/entities/movie_details_entity.dart';
import 'package:movies_app/features/movie_details/domain/entities/related_movie_entity.dart';
import 'package:movies_app/features/movie_details/domain/repos/movie_details_repository.dart';

class MovieDetailsRepositoryImpl implements MovieDetailsRepository {
  const MovieDetailsRepositoryImpl(this._remote);

  final MovieDetailsRemoteDataSource _remote;

  @override
  Future<AppResult<MovieDetailsEntity>> getMovieDetails(int movieId) async {
    final result = await _remote.getMovieDetails(movieId);
    return switch (result) {
      Success(:final data) when data.isMissing => const Failure(
        AppErrorModel(code: 'movie-not-found'),
      ),
      Success(:final data) => Success(data),
      Failure(:final error) => Failure(error),
    };
  }

  @override
  Future<AppResult<List<RelatedMovieEntity>>> getMovieSuggestions(
    int movieId,
  ) async {
    final result = await _remote.getMovieSuggestions(movieId);
    return switch (result) {
      Success(:final data) => Success(data.movies),
      Failure(:final error) => Failure(error),
    };
  }
}
