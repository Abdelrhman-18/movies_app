import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_radius.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_text_styles.dart';

class CastMemberCard extends StatelessWidget {
  const CastMemberCard({
    required this.avatarUrl,
    required this.name,
    required this.character,
    super.key,
  });

  final String avatarUrl;
  final String name;
  final String character;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.small,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.all(AppSpacing.sm),
        child: Row(
          children: [
            ClipOval(
              child: SizedBox.square(
                dimension: AppSizes.castImage,
                child: CachedNetworkImage(
                  imageUrl: avatarUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Shimmer.fromColors(
                    baseColor: AppColors.surface,
                    highlightColor: AppColors.textSecondary,
                    child: const ColoredBox(color: AppColors.surface),
                  ),
                  errorWidget: (_, _, _) => ColoredBox(
                    color: AppColors.surface,
                    child: Icon(
                      Icons.person_rounded,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${context.l10n.name} : $name',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs / 2),
                  Text(
                    '${context.l10n.character} : $character',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
