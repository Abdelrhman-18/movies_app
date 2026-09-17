import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_spacing.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({this.onTap, super.key});

  final VoidCallback? onTap;

  static const double _dimensionDesignPx = 72;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox.square(
          dimension: _dimensionDesignPx.r,
          child: Icon(
            Icons.play_arrow_rounded,
            size: AppSizes.icon,
            color: AppColors.primaryText,
          ),
        ),
      ),
    );
  }
}
