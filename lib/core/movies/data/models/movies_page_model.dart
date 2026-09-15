import 'package:equatable/equatable.dart';

import 'package:movies_app/core/movies/data/models/movie_model.dart';

class MoviesPageModel extends Equatable {
  const MoviesPageModel({
    required this.movieCount,
    required this.pageNumber,
    required this.movies,
  });

  factory MoviesPageModel.fromJson(Map<String, dynamic> json) {
    return MoviesPageModel(
      movieCount: json['movie_count'] as int? ?? 0,
      pageNumber: json['page_number'] as int? ?? 1,
      movies:
          (json['movies'] as List<dynamic>?)
              ?.map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MovieModel>[],
    );
  }

  final int movieCount;
  final int pageNumber;
  final List<MovieModel> movies;

  @override
  List<Object?> get props => [movieCount, pageNumber, movies];
}
