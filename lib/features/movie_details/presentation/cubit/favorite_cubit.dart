import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/movie_details/domain/entities/wishlist_item.dart';
import 'package:movies_app/features/movie_details/domain/usecases/add_to_wishlist_usecase.dart';
import 'package:movies_app/features/movie_details/domain/usecases/check_is_favorite_usecase.dart';
import 'package:movies_app/features/movie_details/domain/usecases/record_movie_history_usecase.dart';
import 'package:movies_app/features/movie_details/domain/usecases/remove_from_wishlist_usecase.dart';
import 'package:movies_app/features/movie_details/presentation/cubit/favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit(
    this._checkIsFavorite,
    this._addToWishlist,
    this._removeFromWishlist,
    this._recordHistory,
  ) : super(const FavoriteInitial());

  final CheckIsFavoriteUseCase _checkIsFavorite;
  final AddToWishlistUseCase _addToWishlist;
  final RemoveFromWishlistUseCase _removeFromWishlist;
  final RecordMovieHistoryUseCase _recordHistory;

  Future<void> load(WishlistItem movie) async {
    emit(const FavoriteLoading());

    unawaited(_recordHistory(movie));

    final result = await _checkIsFavorite(movie.movieId);

    emit(switch (result) {
      Success(:final data) => FavoriteLoaded(data),
      Failure(:final error) => FavoriteError(error),
    });
  }

  Future<void> toggle(WishlistItem movie) async {
    final current = state;
    if (current is! FavoriteLoaded) return;

    final wasFavorite = current.isFavorite;
    emit(FavoriteLoaded(!wasFavorite));

    final result = wasFavorite
        ? await _removeFromWishlist(movie.movieId)
        : await _addToWishlist(movie);

    if (result case Failure(:final error)) {
      emit(FavoriteError(error));
      emit(FavoriteLoaded(wasFavorite));
    }
  }
}
