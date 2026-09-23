import 'package:equatable/equatable.dart';

import 'package:movies_app/core/error/app_error_model.dart';

import 'package:movies_app/features/profile/domain/entities/wishlist_item.dart';

sealed class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object?> get props => [];
}

final class WishlistLoading extends WishlistState {
  const WishlistLoading();
}

final class WishlistSuccess extends WishlistState {
  const WishlistSuccess(this.movies);

  final List<WishlistItem> movies;

  @override
  List<Object?> get props => [movies];
}

final class WishlistEmpty extends WishlistState {
  const WishlistEmpty();
}

final class WishlistError extends WishlistState {
  const WishlistError(this.error);

  final AppErrorModel error;

  @override
  List<Object?> get props => [error];
}
