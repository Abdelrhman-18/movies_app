import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/profile/domain/entities/wishlist_item.dart';
import 'package:movies_app/features/profile/domain/repos/profile_lists_repository.dart';

class GetHistoryUseCase {
  const GetHistoryUseCase(this._repository);

  final ProfileListsRepository _repository;

  Future<AppResult<List<WishlistItem>>> call() {
    return _repository.getHistory();
  }
}
