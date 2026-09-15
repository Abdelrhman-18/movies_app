import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/home/domain/entities/movie_entity.dart';
import 'package:movies_app/features/home/domain/repos/movies_repository.dart';

class GetMoviesUseCase {
  const GetMoviesUseCase(this._repository);

  final MoviesRepository _repository;

  Future<AppResult<List<MovieEntity>>> call({
    int page = 1,
    int limit = 20,
    String? query,
    String? genre,
    String? sortBy,
    String? orderBy,
    double? minimumRating,
  }) => _repository.getMovies(
    page: page,
    limit: limit,
    query: query,
    genre: genre,
    sortBy: sortBy,
    orderBy: orderBy,
    minimumRating: minimumRating,
  );
}
