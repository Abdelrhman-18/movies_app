import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/profile/domain/usecases/get_wishlist_usecase.dart';
import 'package:movies_app/features/profile/presentation/cubit/wishlist/wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit(this._getWishlist) : super(const WishlistLoading());

  final GetWishlistUseCase _getWishlist;

  Future<void> load() async {
    emit(const WishlistLoading());

    final result = await _getWishlist();

    emit(switch (result) {
      Success(:final data) when data.isEmpty => const WishlistEmpty(),
      Success(:final data) => WishlistSuccess(data),
      Failure(:final error) => WishlistError(error),
    });
  }
}
