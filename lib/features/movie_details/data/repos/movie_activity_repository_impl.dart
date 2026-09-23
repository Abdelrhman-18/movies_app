import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/movie_details/data/datasources/movie_activity_service.dart';
import 'package:movies_app/features/movie_details/domain/entities/wishlist_item.dart';
import 'package:movies_app/features/movie_details/domain/repos/movie_activity_repository.dart';

class MovieActivityRepositoryImpl implements MovieActivityRepository {
  const MovieActivityRepositoryImpl(this._service);

  final MovieActivityService _service;

  @override
  Future<AppResult<bool>> isFavorite(int movieId) {
    return _service.isFavorite(movieId);
  }

  @override
  Future<AppResult<void>> addToWishlist(WishlistItem movie) {
    return _service.addToWishlist(movie);
  }

  @override
  Future<AppResult<void>> removeFromWishlist(int movieId) {
    return _service.removeFromWishlist(movieId);
  }

  @override
  Future<AppResult<void>> recordHistory(WishlistItem movie) {
    return _service.recordHistory(movie);
  }
}
