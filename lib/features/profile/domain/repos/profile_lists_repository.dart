import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/profile/domain/entities/wishlist_item.dart';

abstract interface class ProfileListsRepository {
  Future<AppResult<List<WishlistItem>>> getWishlist();

  Future<AppResult<List<WishlistItem>>> getHistory();
}
