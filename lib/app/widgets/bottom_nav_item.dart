import 'package:flutter/material.dart';

import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_spacing.dart';

class BottomNavItem extends StatelessWidget {
  const BottomNavItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
    required this.semanticLabel,
    super.key,
  });

  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        label: semanticLabel,
        selected: isActive,
        button: true,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Center(
            child: Icon(
              icon,
              size: AppSizes.icon,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
