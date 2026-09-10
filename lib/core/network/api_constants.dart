abstract final class ApiConstants {
  static const String baseUrl = 'https://movies-api.accel.li/api/v2/';

  static const String listMovies = 'list_movies.json';
  static const String movieDetails = 'movie_details.json';
  static const String movieSuggestions = 'movie_suggestions.json';

  static const String queryTerm = 'query_term';
  static const String page = 'page';
  static const String limit = 'limit';
  static const String genre = 'genre';
  static const String quality = 'quality';
  static const String sortBy = 'sort_by';
  static const String orderBy = 'order_by';
  static const String minimumRating = 'minimum_rating';
  static const String movieId = 'movie_id';
  static const String withImages = 'with_images';
  static const String withCast = 'with_cast';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
