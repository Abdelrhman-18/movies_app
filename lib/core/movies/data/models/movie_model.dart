import 'package:movies_app/core/movies/domain/entities/movie_entity.dart';

class MovieModel extends MovieEntity {
  const MovieModel({
    required super.id,
    required super.title,
    required super.year,
    required super.rating,
    required super.posterUrl,
    required super.genres,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as int? ?? 0,
      title: json['title_long'] as String? ?? json['title'] as String? ?? '',
      year: json['year'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      posterUrl: json['medium_cover_image'] as String? ?? '',
      genres:
          (json['genres'] as List<dynamic>?)?.cast<String>() ??
          const <String>[],
    );
  }

  /// The API returns `status: "ok"` with `id == 0` for a movie that does not
  /// exist.
  bool get isMissing => id == 0;
}
