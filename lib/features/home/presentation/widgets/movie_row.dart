import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/widgets/poster_card.dart';

import 'package:movies_app/features/home/domain/entities/movie_entity.dart';

class MovieRow extends StatelessWidget {
  const MovieRow({required this.movies, super.key});

  final List<MovieEntity> movies;

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
        itemBuilder: (context, index) => PosterCard(
          posterUrl: movies[index].posterUrl,
          rating: movies[index].rating,
        ),
      ),
    );
  }
}
