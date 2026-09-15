import 'package:flutter/material.dart';

import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_text_styles.dart';

class RatingBadge extends StatelessWidget {
  const RatingBadge({required this.rating, super.key});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.posterOverlay,
        shape: StadiumBorder(),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: AppSizes.badgeHorizontalPadding,
          vertical: AppSizes.badgeVerticalPadding / 2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.star_rounded,
              size: AppSizes.iconSmall,
              color: AppColors.primary,
            ),
            SizedBox(width: AppSpacing.xs / 2),
            Text(
              rating.toStringAsFixed(1),
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
