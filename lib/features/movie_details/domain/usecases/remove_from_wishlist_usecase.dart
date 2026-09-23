import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/movie_details/domain/repos/movie_activity_repository.dart';

class RemoveFromWishlistUseCase {
  const RemoveFromWishlistUseCase(this._repository);

  final MovieActivityRepository _repository;

  Future<AppResult<void>> call(int movieId) {
    return _repository.removeFromWishlist(movieId);
  }
}
