import 'package:equatable/equatable.dart';

class RelatedMovieEntity extends Equatable {
  const RelatedMovieEntity({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.posterUrl,
  });

  final int id;
  final String title;
  final int year;
  final double rating;
  final String posterUrl;

  @override
  List<Object?> get props => [id, title, year, rating, posterUrl];
}
