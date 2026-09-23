import 'package:movies_app/features/movie_details/data/models/cast_member_model.dart';
import 'package:movies_app/features/movie_details/domain/entities/movie_details_entity.dart';

class MovieDetailsModel extends MovieDetailsEntity {
  const MovieDetailsModel({
    required super.id,
    required super.title,
    required super.year,
    required super.rating,
    required super.runtimeMinutes,
    required super.likeCount,
    required super.summary,
    required super.genres,
    required super.backdropUrl,
    required super.posterUrl,
    required super.screenshotUrls,
    required super.cast,
  });

  static const List<String> _screenshotKeys = [
    'large_screenshot_image1',
    'large_screenshot_image2',
    'large_screenshot_image3',
  ];

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailsModel(
      id: json['id'] as int? ?? 0,
      title: json['title_long'] as String? ?? json['title'] as String? ?? '',
      year: json['year'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      runtimeMinutes: json['runtime'] as int? ?? 0,
      likeCount: json['like_count'] as int? ?? 0,
      summary:
          json['description_full'] as String? ??
          json['synopsis'] as String? ??
          json['summary'] as String? ??
          '',
      genres:
          (json['genres'] as List<dynamic>?)?.cast<String>() ??
          const <String>[],
      backdropUrl: json['background_image'] as String? ?? '',
      posterUrl:
          json['large_cover_image'] as String? ??
          json['medium_cover_image'] as String? ??
          '',
      screenshotUrls: [
        for (final key in _screenshotKeys)
          if (json[key] case final String url when url.isNotEmpty) url,
      ],
      cast:
          (json['cast'] as List<dynamic>?)
              ?.map((e) => CastMemberModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CastMemberModel>[],
    );
  }

  /// The API returns `status: "ok"` with `id == 0` for a movie that does not
  /// exist.
  bool get isMissing => id == 0;
}
