import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movies_app/core/error/app_error_model.dart';
import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/browse/presentation/cubit/browse_cubit.dart';
import 'package:movies_app/features/browse/presentation/cubit/browse_state.dart';
import 'package:movies_app/features/home/domain/entities/movie_entity.dart';
import 'package:movies_app/features/home/domain/repos/movies_repository.dart';
import 'package:movies_app/features/home/domain/usecases/get_movies_usecase.dart';

class _MockMoviesRepository extends Mock implements MoviesRepository {}

MovieEntity _movie(int id, List<String> genres) => MovieEntity(
  id: id,
  title: 'Movie $id',
  year: 2020,
  rating: 7,
  posterUrl: '',
  genres: genres,
);

void main() {
  late _MockMoviesRepository repository;
  late BrowseCubit cubit;

  setUp(() {
    repository = _MockMoviesRepository();
    cubit = BrowseCubit(GetMoviesUseCase(repository));
  });

  tearDown(() => cubit.close());

  void stubGetMovies(AppResult<List<MovieEntity>> result) {
    when(
      () => repository.getMovies(
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

  group('BrowseCubit', () {
    test('initial state is BrowseLoading', () {
      expect(cubit.state, const BrowseLoading());
    });

    test(
      'loadMovies emits BrowseSuccess filtered to the first genre',
      () async {
        stubGetMovies(
          Success([
            _movie(1, ['Action']),
            _movie(2, ['Comedy']),
            _movie(3, ['Action', 'Comedy']),
          ]),
        );

        await cubit.loadMovies();

        final state = cubit.state;
        expect(state, isA<BrowseSuccess>());
        final success = state as BrowseSuccess;
        expect(success.genres, {'Action', 'Comedy'});
        expect(success.selectedGenre, 'Action');
        expect(success.movies.map((m) => m.id), [1, 3]);
      },
    );

    test(
      'loadMovies emits BrowseEmpty when no movies have any genre',
      () async {
        stubGetMovies(const Success([]));

        await cubit.loadMovies();

        expect(cubit.state, const BrowseEmpty(genres: {}, selectedGenre: null));
      },
    );

    test('loadMovies emits BrowseError on failure', () async {
      const error = AppErrorModel(code: 'no-connection');
      stubGetMovies(const Failure(error));

      await cubit.loadMovies();

      expect(
        cubit.state,
        const BrowseError(genres: {}, selectedGenre: null, error: error),
      );
    });

    test('selectGenre re-filters movies to the newly selected genre', () async {
      stubGetMovies(
        Success([
          _movie(1, ['Action']),
          _movie(2, ['Comedy']),
        ]),
      );
      await cubit.loadMovies();

      cubit.selectGenre('Comedy');

      final state = cubit.state as BrowseSuccess;
      expect(state.selectedGenre, 'Comedy');
      expect(state.movies.map((m) => m.id), [2]);
    });

    test(
      'selectGenre emits BrowseEmpty when no movie matches the genre',
      () async {
        stubGetMovies(
          Success([
            _movie(1, ['Action']),
          ]),
        );
        await cubit.loadMovies();

        cubit.selectGenre('Documentary');

        expect(cubit.state, isA<BrowseEmpty>());
        expect((cubit.state as BrowseEmpty).selectedGenre, 'Documentary');
      },
    );

    test('retry reloads movies from the repository', () async {
      stubGetMovies(
        Success([
          _movie(1, ['Action']),
        ]),
      );

      final nextState = cubit.stream.firstWhere((s) => s is BrowseSuccess);
      cubit.retry();
      await nextState;

      expect(cubit.state, isA<BrowseSuccess>());
    });
  });
}
