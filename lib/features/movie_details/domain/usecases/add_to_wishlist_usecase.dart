import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/movie_details/domain/entities/wishlist_item.dart';
import 'package:movies_app/features/movie_details/domain/repos/movie_activity_repository.dart';

class AddToWishlistUseCase {
  const AddToWishlistUseCase(this._repository);

  final MovieActivityRepository _repository;

  Future<AppResult<void>> call(WishlistItem movie) {
    return _repository.addToWishlist(movie);
  }
}
