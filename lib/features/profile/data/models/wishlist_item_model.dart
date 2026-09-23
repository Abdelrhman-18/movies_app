import 'package:movies_app/features/profile/domain/entities/wishlist_item.dart';

class WishlistItemModel extends WishlistItem {
  const WishlistItemModel({
    required super.movieId,
    required super.title,
    required super.posterUrl,
    required super.rating,
  });

  factory WishlistItemModel.fromJson(
    Map<String, dynamic> json,
    String documentId,
  ) {
    return WishlistItemModel(
      movieId: int.tryParse(documentId) ?? 0,
      title: json['title'] as String? ?? '',
      posterUrl: json['posterUrl'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
    );
  }
}
