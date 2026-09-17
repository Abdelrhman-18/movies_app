import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_radius.dart';

class ScreenshotCard extends StatelessWidget {
  const ScreenshotCard({
    required this.imageUrl,
    required this.width,
    super.key,
  });

  static const double aspectRatio = 16 / 9;

  final String imageUrl;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: ClipRRect(
          borderRadius: AppRadius.small,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (_, _) => Shimmer.fromColors(
              baseColor: AppColors.surface,
              highlightColor: AppColors.textSecondary,
              child: const ColoredBox(color: AppColors.surface),
            ),
            errorWidget: (_, _, _) => ColoredBox(
              color: AppColors.surface,
              child: Icon(Icons.image_outlined, color: AppColors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}
