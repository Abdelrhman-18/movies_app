import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_radius.dart';
import 'package:movies_app/core/theme/app_spacing.dart';

import 'package:movies_app/core/widgets/rating_badge.dart';

class PosterCard extends StatelessWidget {
  const PosterCard({
    required this.posterUrl,
    required this.rating,
    this.width,
    super.key,
  });

  static const double aspectRatio = 2 / 3;

  final String posterUrl;
  final double rating;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final poster = AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: AppRadius.large,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: posterUrl,
              fit: BoxFit.cover,
              placeholder: (_, _) => Shimmer.fromColors(
                baseColor: AppColors.surface,
                highlightColor: AppColors.textSecondary,
                child: const ColoredBox(color: AppColors.surface),
              ),
              errorWidget: (_, _, _) => ColoredBox(
                color: AppColors.surface,
                child: Icon(
                  Icons.movie_outlined,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            PositionedDirectional(
              top: AppSpacing.xs,
              start: AppSpacing.xs,
              child: RatingBadge(rating: rating),
            ),
          ],
        ),
      ),
    );

    return width == null ? poster : SizedBox(width: width, child: poster);
  }
}
