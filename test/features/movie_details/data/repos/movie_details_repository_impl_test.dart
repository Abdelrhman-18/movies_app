import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movies_app/core/error/app_error_model.dart';
import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/movie_details/data/datasources/movie_details_remote_data_source.dart';
import 'package:movies_app/features/movie_details/data/models/movie_details_model.dart';
import 'package:movies_app/features/movie_details/data/models/movie_suggestions_model.dart';
import 'package:movies_app/features/movie_details/data/models/related_movie_model.dart';
import 'package:movies_app/features/movie_details/data/repos/movie_details_repository_impl.dart';

class _MockMovieDetailsRemoteDataSource extends Mock
    implements MovieDetailsRemoteDataSource {}

void main() {
  late _MockMovieDetailsRemoteDataSource dataSource;
  late MovieDetailsRepositoryImpl repository;

  setUp(() {
    dataSource = _MockMovieDetailsRemoteDataSource();
    repository = MovieDetailsRepositoryImpl(dataSource);
  });

  group('getMovieDetails', () {
    test('returns the movie on success', () async {
      const model = MovieDetailsModel(
        id: 1,
        title: 'A',
        year: 2020,
        rating: 7,
        runtimeMinutes: 90,
        likeCount: 5,
        summary: '',
        genres: [],
        backdropUrl: '',
        posterUrl: '',
        screenshotUrls: [],
        cast: [],
      );
      when(
        () => dataSource.getMovieDetails(1),
      ).thenAnswer((_) async => const Success(model));

      final result = await repository.getMovieDetails(1);

      expect(result, isA<Success>());
      expect((result as Success).data, model);
    });

    test('maps a missing movie (id 0) to a movie-not-found failure', () async {
      const model = MovieDetailsModel(
        id: 0,
        title: '',
        year: 0,
        rating: 0,
        runtimeMinutes: 0,
        likeCount: 0,
        summary: '',
        genres: [],
        backdropUrl: '',
        posterUrl: '',
        screenshotUrls: [],
        cast: [],
      );
      when(
        () => dataSource.getMovieDetails(999),
      ).thenAnswer((_) async => const Success(model));

      final result = await repository.getMovieDetails(999);

      expect(result, isA<Failure>());
      expect((result as Failure).error.code, 'movie-not-found');
    });

    test('propagates the underlying failure unchanged', () async {
      const error = AppErrorModel(
        code: 'timeout',
        message: 'Connection timeout',
      );
      when(
        () => dataSource.getMovieDetails(1),
      ).thenAnswer((_) async => const Failure(error));

      final result = await repository.getMovieDetails(1);

      expect(result, isA<Failure>());
      expect((result as Failure).error, error);
    });
  });

  group('getMovieSuggestions', () {
    test(
      'unwraps the suggestions into just the movie list on success',
      () async {
        when(() => dataSource.getMovieSuggestions(1)).thenAnswer(
          (_) async => const Success(
            MovieSuggestionsModel(
              movies: [
                RelatedMovieModel(
                  id: 2,
                  title: 'B',
                  year: 2021,
                  rating: 8,
                  posterUrl: '',
                ),
              ],
            ),
          ),
        );

        final result = await repository.getMovieSuggestions(1);

        expect(result, isA<Success>());
        final movies = (result as Success).data as List;
        expect(movies.map((m) => m.title), ['B']);
      },
    );

    test('propagates the underlying failure unchanged', () async {
      const error = AppErrorModel(code: 'no-connection', message: 'offline');
      when(
        () => dataSource.getMovieSuggestions(1),
      ).thenAnswer((_) async => const Failure(error));

      final result = await repository.getMovieSuggestions(1);

      expect(result, isA<Failure>());
      expect((result as Failure).error, error);
    });
  });
}
