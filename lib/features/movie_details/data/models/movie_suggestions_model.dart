import 'package:equatable/equatable.dart';

import 'package:movies_app/features/movie_details/data/models/related_movie_model.dart';

class MovieSuggestionsModel extends Equatable {
  const MovieSuggestionsModel({required this.movies});

  factory MovieSuggestionsModel.fromJson(Map<String, dynamic> json) {
    return MovieSuggestionsModel(
      movies:
          (json['movies'] as List<dynamic>?)
              ?.map(
                (e) => RelatedMovieModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <RelatedMovieModel>[],
    );
  }

  final List<RelatedMovieModel> movies;

  @override
  List<Object?> get props => [movies];
}
