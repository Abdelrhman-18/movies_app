import 'package:flutter/material.dart';

import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_theme.dart';

class ProfileStat extends StatelessWidget {
  const ProfileStat({required this.count, required this.label, super.key});

  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$count', style: context.textTheme.titleMedium),
        SizedBox(height: AppSpacing.xs / 2),
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
