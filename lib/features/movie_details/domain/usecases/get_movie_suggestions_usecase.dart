import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/movie_details/domain/entities/related_movie_entity.dart';
import 'package:movies_app/features/movie_details/domain/repos/movie_details_repository.dart';

class GetMovieSuggestionsUseCase {
  const GetMovieSuggestionsUseCase(this._repository);

  final MovieDetailsRepository _repository;

  Future<AppResult<List<RelatedMovieEntity>>> call(int movieId) =>
      _repository.getMovieSuggestions(movieId);
}
