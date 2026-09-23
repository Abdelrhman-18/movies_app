import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/movie_details/domain/entities/movie_details_entity.dart';
import 'package:movies_app/features/movie_details/domain/entities/related_movie_entity.dart';

abstract class MovieDetailsRepository {
  Future<AppResult<MovieDetailsEntity>> getMovieDetails(int movieId);

  Future<AppResult<List<RelatedMovieEntity>>> getMovieSuggestions(int movieId);
}
