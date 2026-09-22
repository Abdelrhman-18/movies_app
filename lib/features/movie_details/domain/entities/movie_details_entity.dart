import 'package:equatable/equatable.dart';

import 'package:movies_app/features/movie_details/domain/entities/cast_member_entity.dart';

class MovieDetailsEntity extends Equatable {
  const MovieDetailsEntity({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.runtimeMinutes,
    required this.likeCount,
    required this.summary,
    required this.genres,
    required this.backdropUrl,
    required this.posterUrl,
    required this.screenshotUrls,
    required this.cast,
  });

  final int id;
  final String title;
  final int year;
  final double rating;
  final int runtimeMinutes;
  final int likeCount;
  final String summary;
  final List<String> genres;
  final String backdropUrl;
  final String posterUrl;
  final List<String> screenshotUrls;
  final List<CastMemberEntity> cast;

  @override
  List<Object?> get props => [
    id,
    title,
    year,
    rating,
    runtimeMinutes,
    likeCount,
    summary,
    genres,
    backdropUrl,
    posterUrl,
    screenshotUrls,
    cast,
  ];
}
