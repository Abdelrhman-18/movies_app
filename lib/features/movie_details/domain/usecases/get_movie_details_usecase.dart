import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/movie_details/domain/entities/movie_details_entity.dart';
import 'package:movies_app/features/movie_details/domain/repos/movie_details_repository.dart';

class GetMovieDetailsUseCase {
  const GetMovieDetailsUseCase(this._repository);

  final MovieDetailsRepository _repository;

  Future<AppResult<MovieDetailsEntity>> call(int movieId) =>
      _repository.getMovieDetails(movieId);
}
