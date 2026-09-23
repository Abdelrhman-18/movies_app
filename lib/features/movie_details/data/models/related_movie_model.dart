import 'package:movies_app/features/movie_details/domain/entities/related_movie_entity.dart';

class RelatedMovieModel extends RelatedMovieEntity {
  const RelatedMovieModel({
    required super.id,
    required super.title,
    required super.year,
    required super.rating,
    required super.posterUrl,
  });

  factory RelatedMovieModel.fromJson(Map<String, dynamic> json) {
    return RelatedMovieModel(
      id: json['id'] as int? ?? 0,
      title: json['title_long'] as String? ?? json['title'] as String? ?? '',
      year: json['year'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      posterUrl: json['medium_cover_image'] as String? ?? '',
    );
  }
}
