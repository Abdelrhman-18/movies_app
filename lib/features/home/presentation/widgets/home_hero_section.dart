import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:movies_app/core/constants/app_assets.dart';
import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_spacing.dart';

import 'package:movies_app/features/home/domain/entities/movie_entity.dart';
import 'package:movies_app/features/home/presentation/widgets/hero_carousel.dart';

class HomeHeroSection extends StatefulWidget {
  const HomeHeroSection({required this.movies, super.key});

  final List<MovieEntity> movies;

  @override
  State<HomeHeroSection> createState() => _HomeHeroSectionState();
}

class _HomeHeroSectionState extends State<HomeHeroSection> {
  late int _focusedIndex = widget.movies.length ~/ 2;

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) return const SizedBox.shrink();

    return Stack(
      children: [
        Positioned.fill(
          child: _HeroBackdrop(
            posterUrl: widget.movies[_focusedIndex].posterUrl,
          ),
        ),
        Column(
          children: [
            SizedBox(height: AppSpacing.xs),
            Semantics(
              label: context.l10n.availableNow,
              image: true,
              child: Image.asset(
                AppAssets.homeAvailableNowTitle,
                height: 93.h,
                excludeFromSemantics: true,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            HeroCarousel(
              movies: widget.movies,
              onFocusedIndexChanged: (index) =>
                  setState(() => _focusedIndex = index),
            ),
            SizedBox(height: AppSpacing.lg),
            Semantics(
              label: context.l10n.watchNow,
              image: true,
              child: Image.asset(
                AppAssets.homeWatchNowTitle,
                height: 146.h,
                excludeFromSemantics: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroBackdrop extends StatelessWidget {
  const _HeroBackdrop({required this.posterUrl});

  final String posterUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          key: ValueKey(posterUrl),
          imageUrl: posterUrl,
          fit: BoxFit.cover,
          placeholder: (_, _) => const ColoredBox(color: AppColors.surface),
          errorWidget: (_, _, _) => const ColoredBox(color: AppColors.surface),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0, 0.465, 1],
              colors: [
                AppColors.background.withValues(alpha: 0.8),
                AppColors.background.withValues(alpha: 0.6),
                AppColors.background,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
