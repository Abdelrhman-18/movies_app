import 'package:flutter/material.dart';

import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/widgets/poster_card.dart';

import 'package:movies_app/features/profile/domain/entities/wishlist_item.dart';

class WishlistMoviesGrid extends StatelessWidget {
  const WishlistMoviesGrid({required this.movies, super.key});

  final List<WishlistItem> movies;

  static const int _crossAxisCount = 3;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.screenPadding,
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _crossAxisCount,
          crossAxisSpacing: AppSpacing.gridSpacing,
          mainAxisSpacing: AppSpacing.gridSpacing,
          childAspectRatio: PosterCard.aspectRatio,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => PosterCard(
            posterUrl: movies[index].posterUrl,
            rating: movies[index].rating,
          ),
          childCount: movies.length,
        ),
      ),
    );
  }
}
