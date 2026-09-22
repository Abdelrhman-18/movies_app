import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movies_app/core/utils/app_result.dart';
import 'package:movies_app/features/home/domain/entities/movie_entity.dart';
import 'package:movies_app/features/home/domain/usecases/get_movies_usecase.dart';
import 'package:movies_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:movies_app/features/search/presentation/cubit/search_state.dart';

class MockGetMoviesUseCase extends Mock implements GetMoviesUseCase {}

void main() {
  late MockGetMoviesUseCase mockGetMoviesUseCase;

  // نفس الأفلام الوهمية اللي كانت جوه الـ Cubit، دلوقتي بنتحكم فيها إحنا من برا
  const dummyMovies = [
    MovieEntity(id: 1, title: 'Neon Horizon', year: 2020, rating: 7.8, posterUrl: '', genres: []),
    MovieEntity(id: 2, title: 'Quiet Streets', year: 2019, rating: 6.5, posterUrl: '', genres: []),
    MovieEntity(id: 3, title: 'Laugh Track', year: 2021, rating: 7.1, posterUrl: '', genres: []),
    MovieEntity(id: 4, title: 'The Basement', year: 2018, rating: 6.9, posterUrl: '', genres: []),
    MovieEntity(id: 5, title: 'Second Orbit', year: 2022, rating: 8.2, posterUrl: '', genres: []),
    MovieEntity(id: 6, title: 'Letters Home', year: 2017, rating: 7.4, posterUrl: '', genres: []),
  ];

  setUp(() {
    mockGetMoviesUseCase = MockGetMoviesUseCase();
    registerFallbackValue(0); // احتياطي لو محتاج fallback لأي argument matcher
  });

  group('SearchCubit', () {
    test('starts in SearchInitial', () {
      final cubit = SearchCubit(mockGetMoviesUseCase);
      addTearDown(cubit.close);

      expect(cubit.state, const SearchInitial());
    });

    test('queryChanged with an empty/blank query resets to SearchInitial', () {
      final cubit = SearchCubit(mockGetMoviesUseCase);
      addTearDown(cubit.close);

      cubit.queryChanged('   ');

      expect(cubit.state, const SearchInitial());
    });

    test(
      'queryChanged debounces and emits SearchSuccess for a match',
          () async {
        when(() => mockGetMoviesUseCase(query: 'orbit')).thenAnswer(
              (_) async => Success([
            dummyMovies.firstWhere((m) => m.title == 'Second Orbit'),
          ]),
        );

        final cubit = SearchCubit(mockGetMoviesUseCase);
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
      when(() => mockGetMoviesUseCase(query: 'nonexistent movie'))
          .thenAnswer((_) async => const Success([]));

      final cubit = SearchCubit(mockGetMoviesUseCase);
      addTearDown(cubit.close);

      cubit.queryChanged('nonexistent movie');

      await Future<void>.delayed(const Duration(milliseconds: 500));

      expect(cubit.state, const SearchEmpty());
    });

    test(
      'rapid queryChanged calls cancel the previous debounce timer',
          () async {
        // مش المفروض تتنادى خالص - الـ debounce المفروض يلغيها
        when(() => mockGetMoviesUseCase(query: 'quiet'))
            .thenAnswer((_) async => const Success([]));

        when(() => mockGetMoviesUseCase(query: 'orbit')).thenAnswer(
              (_) async => Success([
            dummyMovies.firstWhere((m) => m.title == 'Second Orbit'),
          ]),
        );

        final cubit = SearchCubit(mockGetMoviesUseCase);
        addTearDown(cubit.close);

        cubit.queryChanged('quiet');
        await Future<void>.delayed(const Duration(milliseconds: 200));
        cubit.queryChanged('orbit');

        await Future<void>.delayed(const Duration(milliseconds: 500));

        final state = cubit.state as SearchSuccess;
        expect(state.movies.single.title, 'Second Orbit');

        // بنتأكد إن quiet فعلاً ما اتصلتش لأن الـ debounce لغاها
        verifyNever(() => mockGetMoviesUseCase(query: 'quiet'));
      },
    );
  });
}