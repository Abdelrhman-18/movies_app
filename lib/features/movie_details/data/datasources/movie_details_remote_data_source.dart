import 'package:movies_app/core/network/api_client.dart';
import 'package:movies_app/core/network/api_constants.dart';
import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/movie_details/data/models/movie_details_model.dart';
import 'package:movies_app/features/movie_details/data/models/movie_suggestions_model.dart';

class MovieDetailsRemoteDataSource {
  const MovieDetailsRemoteDataSource(this._client);

  final ApiClient _client;

  Future<AppResult<MovieDetailsModel>> getMovieDetails(int movieId) {
    return _client.get<MovieDetailsModel>(
      ApiConstants.movieDetails,
      queryParameters: {
        ApiConstants.movieId: movieId,
        ApiConstants.withImages: true,
        ApiConstants.withCast: true,
      },
      dataFromJson: (data) =>
          MovieDetailsModel.fromJson(data['movie'] as Map<String, dynamic>),
    );
  }

  Future<AppResult<MovieSuggestionsModel>> getMovieSuggestions(int movieId) {
    return _client.get<MovieSuggestionsModel>(
      ApiConstants.movieSuggestions,
      queryParameters: {ApiConstants.movieId: movieId},
      dataFromJson: MovieSuggestionsModel.fromJson,
    );
  }
}
