import 'package:flutter/material.dart';

import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_radius.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_text_styles.dart';

class MetricChip extends StatelessWidget {
  const MetricChip({required this.icon, required this.value, super.key});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.small,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(vertical: AppSpacing.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: AppSizes.iconSmall, color: AppColors.primary),
            SizedBox(width: AppSpacing.xs / 2),
            Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
