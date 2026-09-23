import 'package:equatable/equatable.dart';

class WishlistItem extends Equatable {
  const WishlistItem({
    required this.movieId,
    required this.title,
    required this.posterUrl,
    required this.rating,
  });

  final int movieId;
  final String title;
  final String posterUrl;
  final double rating;

  @override
  List<Object?> get props => [movieId, title, posterUrl, rating];
}
