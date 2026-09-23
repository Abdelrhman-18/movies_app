import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_radius.dart';
import 'package:movies_app/core/theme/app_spacing.dart';

class MovieDetailsLoadingView extends StatelessWidget {
  const MovieDetailsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.textSecondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _block(height: 480.h),
          Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: Column(
              children: [
                _block(height: 20.h, width: 220.w),
                SizedBox(height: AppSpacing.md),
                _block(height: 48.h),
                SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    for (var i = 0; i < 3; i++) ...[
                      if (i != 0) SizedBox(width: AppSpacing.sm),
                      Expanded(child: _block(height: 40.h)),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _block({double? width, double? height}) {
    return ClipRRect(
      borderRadius: AppRadius.small,
      child: SizedBox(
        width: width,
        height: height,
        child: const ColoredBox(color: AppColors.surface),
      ),
    );
  }
}
