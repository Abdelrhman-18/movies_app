import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movies_app/core/error/app_error_model.dart';
import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/movie_details/domain/entities/wishlist_item.dart';
import 'package:movies_app/features/movie_details/domain/repos/movie_activity_repository.dart';
import 'package:movies_app/features/movie_details/domain/usecases/add_to_wishlist_usecase.dart';
import 'package:movies_app/features/movie_details/domain/usecases/check_is_favorite_usecase.dart';
import 'package:movies_app/features/movie_details/domain/usecases/record_movie_history_usecase.dart';
import 'package:movies_app/features/movie_details/domain/usecases/remove_from_wishlist_usecase.dart';
import 'package:movies_app/features/movie_details/presentation/cubit/favorite_cubit.dart';
import 'package:movies_app/features/movie_details/presentation/cubit/favorite_state.dart';

class _MockMovieActivityRepository extends Mock
    implements MovieActivityRepository {}

const _movie = WishlistItem(
  movieId: 1,
  title: 'Movie',
  posterUrl: '',
  rating: 7,
);

void main() {
  late _MockMovieActivityRepository repository;
  late FavoriteCubit cubit;

  setUpAll(() {
    registerFallbackValue(_movie);
  });

  setUp(() {
    repository = _MockMovieActivityRepository();
    when(
      () => repository.recordHistory(any()),
    ).thenAnswer((_) async => const Success(null));
    cubit = FavoriteCubit(
      CheckIsFavoriteUseCase(repository),
      AddToWishlistUseCase(repository),
      RemoveFromWishlistUseCase(repository),
      RecordMovieHistoryUseCase(repository),
    );
  });

  tearDown(() => cubit.close());

  group('FavoriteCubit.load', () {
    test('emits FavoriteLoaded(false) and records history', () async {
      when(
        () => repository.isFavorite(_movie.movieId),
      ).thenAnswer((_) async => const Success(false));

      await cubit.load(_movie);

      expect(cubit.state, const FavoriteLoaded(false));
      verify(() => repository.recordHistory(_movie)).called(1);
    });

    test('emits FavoriteError on failure', () async {
      const error = AppErrorModel(code: 'no-connection', message: 'offline');
      when(
        () => repository.isFavorite(_movie.movieId),
      ).thenAnswer((_) async => const Failure(error));

      await cubit.load(_movie);

      expect(cubit.state, const FavoriteError(error));
    });
  });

  group('FavoriteCubit.toggle', () {
    test('adds to the wishlist when not currently favorited', () async {
      when(
        () => repository.isFavorite(_movie.movieId),
      ).thenAnswer((_) async => const Success(false));
      when(
        () => repository.addToWishlist(any()),
      ).thenAnswer((_) async => const Success(null));
      await cubit.load(_movie);

      await cubit.toggle(_movie);

      expect(cubit.state, const FavoriteLoaded(true));
      verify(() => repository.addToWishlist(_movie)).called(1);
    });

    test('removes from the wishlist when currently favorited', () async {
      when(
        () => repository.isFavorite(_movie.movieId),
      ).thenAnswer((_) async => const Success(true));
      when(
        () => repository.removeFromWishlist(_movie.movieId),
      ).thenAnswer((_) async => const Success(null));
      await cubit.load(_movie);

      await cubit.toggle(_movie);

      expect(cubit.state, const FavoriteLoaded(false));
      verify(() => repository.removeFromWishlist(_movie.movieId)).called(1);
    });

    test('reverts to the previous state when the write fails', () async {
      const error = AppErrorModel(code: 'no-connection', message: 'offline');
      when(
        () => repository.isFavorite(_movie.movieId),
      ).thenAnswer((_) async => const Success(false));
      when(
        () => repository.addToWishlist(any()),
      ).thenAnswer((_) async => const Failure(error));
      await cubit.load(_movie);

      await cubit.toggle(_movie);

      expect(cubit.state, const FavoriteLoaded(false));
    });
  });
}
