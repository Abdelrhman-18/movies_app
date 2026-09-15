import 'package:movies_app/core/movies/domain/entities/movie_entity.dart';
import 'package:movies_app/core/utils/app_result.dart';

abstract class MoviesRepository {
  Future<AppResult<List<MovieEntity>>> getMovies({
    int page = 1,
    int limit = 20,
    String? query,
    String? genre,
    String? sortBy,
    String? orderBy,
    double? minimumRating,
  });
}
