import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/widgets/poster_card.dart';

import 'package:movies_app/features/movie_details/domain/entities/related_movie_entity.dart';

class SuggestionsRow extends StatelessWidget {
  const SuggestionsRow({required this.movies, super.key});

  final List<RelatedMovieEntity> movies;

  static const double _heightDesignPx = 190;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _heightDesignPx.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        itemCount: movies.length,
        separatorBuilder: (_, _) => SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () =>
              context.push(AppRoutes.movieDetailsPath, extra: movies[index].id),
          child: PosterCard(
            posterUrl: movies[index].posterUrl,
            rating: movies[index].rating,
          ),
        ),
      ),
    );
  }
}
