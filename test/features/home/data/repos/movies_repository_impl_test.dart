import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movies_app/core/error/app_error_model.dart';
import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/home/data/datasources/movies_remote_data_source.dart';
import 'package:movies_app/features/home/data/models/movie_model.dart';
import 'package:movies_app/features/home/data/models/movies_page_model.dart';
import 'package:movies_app/features/home/data/repos/movies_repository_impl.dart';

class _MockMoviesRemoteDataSource extends Mock
    implements MoviesRemoteDataSource {}

void main() {
  late _MockMoviesRemoteDataSource dataSource;
  late MoviesRepositoryImpl repository;

  setUp(() {
    dataSource = _MockMoviesRemoteDataSource();
    repository = MoviesRepositoryImpl(dataSource);
  });

  void stubListMovies(AppResult<MoviesPageModel> result) {
    when(
      () => dataSource.listMovies(
        page: any(named: 'page'),
        limit: any(named: 'limit'),
        query: any(named: 'query'),
        genre: any(named: 'genre'),
        sortBy: any(named: 'sortBy'),
        orderBy: any(named: 'orderBy'),
        minimumRating: any(named: 'minimumRating'),
      ),
    ).thenAnswer((_) async => result);
  }

  test(
    'getMovies unwraps the page into just the movie list on success',
    () async {
      stubListMovies(
        Success(
          MoviesPageModel(
            movieCount: 2,
            pageNumber: 1,
            movies: const [
              MovieModel(
                id: 1,
                title: 'A',
                year: 2020,
                rating: 7,
                posterUrl: '',
                genres: [],
              ),
              MovieModel(
                id: 2,
                title: 'B',
                year: 2021,
                rating: 8,
                posterUrl: '',
                genres: [],
              ),
            ],
          ),
        ),
      );

      final result = await repository.getMovies();

      expect(result, isA<Success>());
      final movies = (result as Success).data as List;
      expect(movies.map((m) => m.title), ['A', 'B']);
    },
  );

  test('getMovies propagates the underlying failure unchanged', () async {
    const error = AppErrorModel(code: 'timeout', message: 'Connection timeout');
    stubListMovies(const Failure(error));

    final result = await repository.getMovies();

    expect(result, isA<Failure>());
    expect((result as Failure).error, error);
  });
}
