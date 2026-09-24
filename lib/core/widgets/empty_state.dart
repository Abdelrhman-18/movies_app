import 'package:flutter/material.dart';

import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_theme.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
     this.message,
    this.icon ,
    this.imagePath,
    super.key,
  });

  final String? message;
  final IconData? icon;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imagePath != null)
            Image.asset(
              imagePath!,
              width: AppSizes.emptyIllustration,
              height: AppSizes.emptyIllustration,
            )
          else
            Container(
              width: AppSizes.emptyIllustration,
              height: AppSizes.emptyIllustration,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: AppSizes.icon * 3,
                color: AppColors.textSecondary,
              ),
            ),
          SizedBox(height: AppSpacing.md),
          // Padding(
          //   padding: EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.xl),
          //   child: Text(
          //     message,
          //     textAlign: TextAlign.center,
          //     style: context.textTheme.bodyMedium?.copyWith(
          //       color: AppColors.textSecondary,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}