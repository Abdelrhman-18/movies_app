import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movies_app/core/error/app_error_model.dart';
import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/home/domain/entities/movie_entity.dart';
import 'package:movies_app/features/home/domain/repos/movies_repository.dart';
import 'package:movies_app/features/home/domain/usecases/get_movies_usecase.dart';
import 'package:movies_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:movies_app/features/home/presentation/cubit/home_state.dart';

class _MockMoviesRepository extends Mock implements MoviesRepository {}

MovieEntity _movie(int id) => MovieEntity(
  id: id,
  title: 'Movie $id',
  year: 2020,
  rating: 7,
  posterUrl: '',
  genres: const ['Action'],
);

void main() {
  late _MockMoviesRepository repository;
  late HomeCubit cubit;

  setUp(() {
    repository = _MockMoviesRepository();
    cubit = HomeCubit(GetMoviesUseCase(repository));
  });

  tearDown(() => cubit.close());

  void stubGetMovies(
    AppResult<List<MovieEntity>> Function(String? genre) answer,
  ) {
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
    ).thenAnswer((invocation) async {
      final genre = invocation.namedArguments[#genre] as String?;
      return answer(genre);
    });
  }

  group('HomeCubit', () {
    test('initial state is HomeLoading', () {
      expect(cubit.state, const HomeLoading());
    });

    test(
      'load emits HomeSuccess with the hero and per-genre categories',
      () async {
        stubGetMovies((genre) {
          if (genre == null) return Success([_movie(1), _movie(2)]);
          return Success([_movie(genre.hashCode)]);
        });

        await cubit.load();

        final state = cubit.state;
        expect(state, isA<HomeSuccess>());
        final success = state as HomeSuccess;
        expect(success.hero, hasLength(2));
        expect(success.categories, hasLength(HomeCubit.categoryGenres.length));
        expect(
          success.categories.map((c) => c.title),
          HomeCubit.categoryGenres,
        );
      },
    );

    test(
      'load emits HomeEmpty when the hero and every category are empty',
      () async {
        stubGetMovies((_) => const Success([]));

        await cubit.load();

        expect(cubit.state, const HomeEmpty());
      },
    );

    test('load emits HomeError as soon as any request fails', () async {
      const error = AppErrorModel(code: 'no-connection', message: 'offline');
      stubGetMovies((genre) {
        if (genre == null) return const Failure(error);
        return Success([_movie(1)]);
      });

      await cubit.load();

      expect(cubit.state, const HomeError(error));
    });
  });
}
