import 'package:flutter/material.dart';

import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_text_styles.dart';

class AppChip extends StatelessWidget {
  const AppChip({
    required this.label,
    required this.isSelected,
    this.onTap,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Container(
          height: AppSizes.genreChipHeight,
          padding: EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.md),
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            shape: StadiumBorder(
              side: BorderSide(
                color: AppColors.primary,
                width: AppSizes.categoryBorderWidth,
              ),
            ),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall.copyWith(
              color: isSelected ? AppColors.primaryText : AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
