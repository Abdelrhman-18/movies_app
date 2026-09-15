import 'package:movies_app/core/movies/data/models/movies_page_model.dart';
import 'package:movies_app/core/network/api_client.dart';
import 'package:movies_app/core/network/api_constants.dart';
import 'package:movies_app/core/utils/app_result.dart';

class MoviesRemoteDataSource {
  const MoviesRemoteDataSource(this._client);

  final ApiClient _client;

  Future<AppResult<MoviesPageModel>> listMovies({
    int page = 1,
    int limit = 20,
    String? query,
    String? genre,
    String? sortBy,
    String? orderBy,
    double? minimumRating,
  }) {
    return _client.get<MoviesPageModel>(
      ApiConstants.listMovies,
      queryParameters: {
        ApiConstants.page: page,
        ApiConstants.limit: limit,
        ApiConstants.queryTerm: ?query,
        ApiConstants.genre: ?genre,
        ApiConstants.sortBy: ?sortBy,
        ApiConstants.orderBy: ?orderBy,
        ApiConstants.minimumRating: ?minimumRating,
      },
      dataFromJson: MoviesPageModel.fromJson,
    );
  }
}
