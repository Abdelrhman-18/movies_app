import 'package:equatable/equatable.dart';

class MovieEntity extends Equatable {
  const MovieEntity({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.posterUrl,
    required this.genres,
  });

  final int id;
  final String title;
  final int year;
  final double rating;
  final String posterUrl;
  final List<String> genres;

  @override
  List<Object?> get props => [id, title, year, rating, posterUrl, genres];
}
