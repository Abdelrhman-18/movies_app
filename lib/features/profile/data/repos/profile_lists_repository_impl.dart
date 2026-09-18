import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/profile/data/datasources/profile_lists_service.dart';
import 'package:movies_app/features/profile/domain/entities/wishlist_item.dart';
import 'package:movies_app/features/profile/domain/repos/profile_lists_repository.dart';

class ProfileListsRepositoryImpl implements ProfileListsRepository {
  const ProfileListsRepositoryImpl(this._service);

  final ProfileListsService _service;

  @override
  Future<AppResult<List<WishlistItem>>> getWishlist() {
    return _service.getWishlist();
  }

  @override
  Future<AppResult<List<WishlistItem>>> getHistory() {
    return _service.getHistory();
  }
}
