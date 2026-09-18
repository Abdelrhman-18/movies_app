import 'package:movies_app/features/movie_details/domain/entities/wishlist_item.dart';

class WishlistItemModel extends WishlistItem {
  const WishlistItemModel({
    required super.movieId,
    required super.title,
    required super.posterUrl,
    required super.rating,
  });

  factory WishlistItemModel.fromEntity(WishlistItem entity) {
    return WishlistItemModel(
      movieId: entity.movieId,
      title: entity.title,
      posterUrl: entity.posterUrl,
      rating: entity.rating,
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'posterUrl': posterUrl, 'rating': rating};
  }
}
