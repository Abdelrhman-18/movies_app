import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movies_app/core/error/app_error_model.dart';
import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/movie_details/domain/entities/movie_details_entity.dart';
import 'package:movies_app/features/movie_details/domain/entities/related_movie_entity.dart';
import 'package:movies_app/features/movie_details/domain/repos/movie_details_repository.dart';
import 'package:movies_app/features/movie_details/domain/usecases/get_movie_details_usecase.dart';
import 'package:movies_app/features/movie_details/domain/usecases/get_movie_suggestions_usecase.dart';
import 'package:movies_app/features/movie_details/presentation/cubit/movie_details_cubit.dart';
import 'package:movies_app/features/movie_details/presentation/cubit/movie_details_state.dart';

class _MockMovieDetailsRepository extends Mock
    implements MovieDetailsRepository {}

const _details = MovieDetailsEntity(
  id: 1,
  title: 'A',
  year: 2020,
  rating: 7,
  runtimeMinutes: 90,
  likeCount: 5,
  summary: 'Summary',
  genres: ['Action'],
  backdropUrl: '',
  posterUrl: '',
  screenshotUrls: [],
  cast: [],
);

const _suggestion = RelatedMovieEntity(
  id: 2,
  title: 'B',
  year: 2021,
  rating: 8,
  posterUrl: '',
);

void main() {
  late _MockMovieDetailsRepository repository;
  late MovieDetailsCubit cubit;

  setUp(() {
    repository = _MockMovieDetailsRepository();
    cubit = MovieDetailsCubit(
      GetMovieDetailsUseCase(repository),
      GetMovieSuggestionsUseCase(repository),
    );
  });

  tearDown(() => cubit.close());

  test('initial state is MovieDetailsLoading', () {
    expect(cubit.state, const MovieDetailsLoading());
  });

  test('load emits MovieDetailsSuccess with details and suggestions', () async {
    when(
      () => repository.getMovieDetails(1),
    ).thenAnswer((_) async => const Success(_details));
    when(
      () => repository.getMovieSuggestions(1),
    ).thenAnswer((_) async => const Success([_suggestion]));

    await cubit.load(1);

    expect(
      cubit.state,
      const MovieDetailsSuccess(details: _details, suggestions: [_suggestion]),
    );
  });

  test('load emits MovieDetailsError when the details request fails', () async {
    const error = AppErrorModel(code: 'movie-not-found');
    when(
      () => repository.getMovieDetails(1),
    ).thenAnswer((_) async => const Failure(error));
    when(
      () => repository.getMovieSuggestions(1),
    ).thenAnswer((_) async => const Success([_suggestion]));

    await cubit.load(1);

    expect(cubit.state, const MovieDetailsError(error));
  });

  test(
    'load falls back to an empty suggestions list when suggestions fail',
    () async {
      when(
        () => repository.getMovieDetails(1),
      ).thenAnswer((_) async => const Success(_details));
      when(() => repository.getMovieSuggestions(1)).thenAnswer(
        (_) async => const Failure(AppErrorModel(code: 'no-connection')),
      );

      await cubit.load(1);

      expect(
        cubit.state,
        const MovieDetailsSuccess(details: _details, suggestions: []),
      );
    },
  );
}
