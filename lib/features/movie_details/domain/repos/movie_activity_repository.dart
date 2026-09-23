import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/movie_details/domain/entities/wishlist_item.dart';

abstract interface class MovieActivityRepository {
  Future<AppResult<bool>> isFavorite(int movieId);

  Future<AppResult<void>> addToWishlist(WishlistItem movie);

  Future<AppResult<void>> removeFromWishlist(int movieId);

  Future<AppResult<void>> recordHistory(WishlistItem movie);
}
