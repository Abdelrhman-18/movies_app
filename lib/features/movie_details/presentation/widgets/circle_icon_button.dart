import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_spacing.dart';

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({required this.icon, this.onTap, super.key});

  final IconData icon;
  final VoidCallback? onTap;

  static const double _dimensionDesignPx = 40;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.posterOverlay,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox.square(
          dimension: _dimensionDesignPx.r,
          child: Icon(
            icon,
            size: AppSizes.iconSmall,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
