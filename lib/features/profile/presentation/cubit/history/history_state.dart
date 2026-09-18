import 'package:equatable/equatable.dart';

import 'package:movies_app/core/error/app_error_model.dart';

import 'package:movies_app/features/profile/domain/entities/wishlist_item.dart';

sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

final class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

final class HistorySuccess extends HistoryState {
  const HistorySuccess(this.movies);

  final List<WishlistItem> movies;

  @override
  List<Object?> get props => [movies];
}

final class HistoryEmpty extends HistoryState {
  const HistoryEmpty();
}

final class HistoryError extends HistoryState {
  const HistoryError(this.error);

  final AppErrorModel error;

  @override
  List<Object?> get props => [error];
}
