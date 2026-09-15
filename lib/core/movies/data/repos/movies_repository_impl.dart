import 'package:movies_app/core/movies/data/datasources/movies_remote_data_source.dart';
import 'package:movies_app/core/movies/domain/entities/movie_entity.dart';
import 'package:movies_app/core/movies/domain/repos/movies_repository.dart';
import 'package:movies_app/core/utils/app_result.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  const MoviesRepositoryImpl(this._remote);

  final MoviesRemoteDataSource _remote;

  @override
  Future<AppResult<List<MovieEntity>>> getMovies({
    int page = 1,
    int limit = 20,
    String? query,
    String? genre,
    String? sortBy,
    String? orderBy,
    double? minimumRating,
  }) async {
    final result = await _remote.listMovies(
      page: page,
      limit: limit,
      query: query,
      genre: genre,
      sortBy: sortBy,
      orderBy: orderBy,
      minimumRating: minimumRating,
    );
    return switch (result) {
      Success(:final data) => Success(data.movies),
      Failure(:final error) => Failure(error),
    };
  }
}
