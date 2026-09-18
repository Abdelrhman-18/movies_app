import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_spacing.dart';

import 'package:movies_app/features/movie_details/presentation/widgets/circle_icon_button.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/play_button.dart';

class HeroMovieHeader extends StatelessWidget {
  const HeroMovieHeader({
    required this.backdropUrl,
    this.isFavorite = false,
    this.onBackTap,
    this.onBookmarkTap,
    this.onPlayTap,
    super.key,
  });

  final String backdropUrl;
  final bool isFavorite;
  final VoidCallback? onBackTap;
  final VoidCallback? onBookmarkTap;
  final VoidCallback? onPlayTap;

  static const double _heightDesignPx = 480;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _heightDesignPx.h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: backdropUrl,
            fit: BoxFit.cover,
            placeholder: (_, _) => Shimmer.fromColors(
              baseColor: AppColors.surface,
              highlightColor: AppColors.textSecondary,
              child: const ColoredBox(color: AppColors.surface),
            ),
            errorWidget: (_, _, _) => ColoredBox(
              color: AppColors.surface,
              child: Icon(Icons.movie_outlined, color: AppColors.textSecondary),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0, 0.6, 1],
                colors: [
                  Colors.transparent,
                  AppColors.background.withValues(alpha: 0.6),
                  AppColors.background,
                ],
              ),
            ),
          ),
          PositionedDirectional(
            top: AppSpacing.lg,
            start: AppSpacing.screenPadding,
            child: CircleIconButton(
              icon: Icons.arrow_back_rounded,
              onTap: onBackTap,
            ),
          ),
          PositionedDirectional(
            top: AppSpacing.lg,
            end: AppSpacing.screenPadding,
            child: CircleIconButton(
              icon: isFavorite
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: isFavorite ? AppColors.primary : AppColors.textPrimary,
              onTap: onBookmarkTap,
            ),
          ),
          Center(child: PlayButton(onTap: onPlayTap)),
        ],
      ),
    );
  }
}
