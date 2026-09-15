import 'package:flutter/material.dart';

import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/theme/app_spacing.dart';

import 'package:movies_app/features/home/domain/entities/movie_entity.dart';
import 'package:movies_app/features/home/presentation/widgets/movie_row.dart';
import 'package:movies_app/features/home/presentation/widgets/section_header.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({
    required this.title,
    required this.movies,
    this.onSeeMoreTap,
    super.key,
  });

  final String title;
  final List<MovieEntity> movies;
  final VoidCallback? onSeeMoreTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: SectionHeader(
            title: title,
            actionLabel: context.l10n.seeMore,
            onActionTap: onSeeMoreTap,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        MovieRow(movies: movies),
      ],
    );
  }
}
