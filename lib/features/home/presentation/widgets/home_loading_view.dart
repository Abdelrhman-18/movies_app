import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_radius.dart';
import 'package:movies_app/core/theme/app_spacing.dart';

class HomeLoadingView extends StatelessWidget {
  const HomeLoadingView({super.key});

  static const int _categoryRows = 3;
  static const int _cardsPerRow = 4;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.textSecondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _block(height: 560.h),
          for (var i = 0; i < _categoryRows; i++) ...[
            SizedBox(height: AppSpacing.xl),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: _block(height: 20.h, width: 96.w),
            ),
            SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 190.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                itemCount: _cardsPerRow,
                separatorBuilder: (_, _) => SizedBox(width: AppSpacing.sm),
                itemBuilder: (_, _) => _block(width: 130.w),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _block({double? width, double? height}) {
    return ClipRRect(
      borderRadius: AppRadius.large,
      child: SizedBox(
        width: width,
        height: height,
        child: const ColoredBox(color: AppColors.surface),
      ),
    );
  }
}
