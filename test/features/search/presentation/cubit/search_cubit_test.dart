import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movies_app/core/utils/app_result.dart';
import 'package:movies_app/features/home/domain/entities/movie_entity.dart';
import 'package:movies_app/features/home/domain/repos/movies_repository.dart';
import 'package:movies_app/features/home/domain/usecases/get_movies_usecase.dart';
import 'package:movies_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:movies_app/features/search/presentation/cubit/search_state.dart';

class _MockMoviesRepository extends Mock implements MoviesRepository {}

MovieEntity _movie(String title) => MovieEntity(
  id: title.hashCode,
  title: title,
  year: 2021,
  rating: 8.0,
  posterUrl: '',
  genres: const ['Action'],
);

void main() {
  late _MockMoviesRepository repository;
  late GetMoviesUseCase useCase;

  setUp(() {
    repository = _MockMoviesRepository();
    useCase = GetMoviesUseCase(repository);
  });

  void stubSearch(String query, List<MovieEntity> results) {
    when(
      () => repository.getMovies(
        query: query,
        page: any(named: 'page'),
        limit: any(named: 'limit'),
        genre: any(named: 'genre'),
        sortBy: any(named: 'sortBy'),
        orderBy: any(named: 'orderBy'),
        minimumRating: any(named: 'minimumRating'),
      ),
    ).thenAnswer((_) async => Success(results));
  }

  group('SearchCubit', () {
    test('starts in SearchInitial', () {
      final cubit = SearchCubit(useCase);
      addTearDown(cubit.close);

      expect(cubit.state, const SearchInitial());
    });

    test('queryChanged with an empty/blank query resets to SearchInitial', () {
      final cubit = SearchCubit(useCase);
      addTearDown(cubit.close);

      cubit.queryChanged('   ');

      expect(cubit.state, const SearchInitial());
    });

    test(
      'queryChanged debounces and emits SearchSuccess for a match',
      () async {
        stubSearch('orbit', [_movie('Second Orbit')]);

        final cubit = SearchCubit(useCase);
        addTearDown(cubit.close);

        cubit.queryChanged('orbit');
        expect(cubit.state, const SearchInitial());

        await Future<void>.delayed(const Duration(milliseconds: 500));

        final state = cubit.state;
        expect(state, isA<SearchSuccess>());
        expect((state as SearchSuccess).movies.single.title, 'Second Orbit');
      },
    );

    test('queryChanged emits SearchEmpty when nothing matches', () async {
      stubSearch('nonexistent movie', []);

      final cubit = SearchCubit(useCase);
      addTearDown(cubit.close);

      cubit.queryChanged('nonexistent movie');

      await Future<void>.delayed(const Duration(milliseconds: 500));

      expect(cubit.state, const SearchEmpty());
    });

    test(
      'rapid queryChanged calls cancel the previous debounce timer',
      () async {
        stubSearch('quiet', [_movie('A Quiet Place')]);
        stubSearch('orbit', [_movie('Second Orbit')]);

        final cubit = SearchCubit(useCase);
        addTearDown(cubit.close);

        cubit.queryChanged('quiet');
        await Future<void>.delayed(const Duration(milliseconds: 200));
        cubit.queryChanged('orbit');

        await Future<void>.delayed(const Duration(milliseconds: 500));

        final state = cubit.state as SearchSuccess;
        expect(state.movies.single.title, 'Second Orbit');
      },
    );
  });
}
