import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_radius.dart';
import 'package:movies_app/core/theme/app_spacing.dart';

import 'package:movies_app/core/widgets/poster_card.dart';

class PosterGridShimmer extends StatelessWidget {
  const PosterGridShimmer({this.itemCount = 6, super.key});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.textSecondary,
      child: GridView.builder(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: PosterCard.aspectRatio,
        ),
        itemCount: itemCount,
        itemBuilder: (_, _) => ClipRRect(
          borderRadius: AppRadius.large,
          child: const ColoredBox(color: AppColors.surface),
        ),
      ),
    );
  }
}
