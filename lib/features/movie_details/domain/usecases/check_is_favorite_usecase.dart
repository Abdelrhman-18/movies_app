import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/movie_details/domain/repos/movie_activity_repository.dart';

class CheckIsFavoriteUseCase {
  const CheckIsFavoriteUseCase(this._repository);

  final MovieActivityRepository _repository;

  Future<AppResult<bool>> call(int movieId) {
    return _repository.isFavorite(movieId);
  }
}
