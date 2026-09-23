import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_text_styles.dart';
import 'package:movies_app/core/theme/app_theme.dart';
import 'package:movies_app/core/widgets/movie_list_error_view.dart';

import 'package:movies_app/features/movie_details/domain/entities/cast_member_entity.dart';
import 'package:movies_app/features/movie_details/domain/entities/movie_details_entity.dart';
import 'package:movies_app/features/movie_details/domain/entities/related_movie_entity.dart';
import 'package:movies_app/features/movie_details/domain/entities/wishlist_item.dart';
import 'package:movies_app/features/movie_details/presentation/cubit/favorite_cubit.dart';
import 'package:movies_app/features/movie_details/presentation/cubit/favorite_state.dart';
import 'package:movies_app/features/movie_details/presentation/cubit/movie_details_cubit.dart';
import 'package:movies_app/features/movie_details/presentation/cubit/movie_details_state.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/cast_member_card.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/genre_chip.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/hero_movie_header.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/metric_chip.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/movie_details_loading_view.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/primary_watch_button.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/screenshot_card.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/section_title.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/suggestions_row.dart';

class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({required this.movieId, super.key});

  final int movieId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MovieDetailsCubit>(
      create: (_) => getIt<MovieDetailsCubit>()..load(movieId),
      child: _MovieDetailsScreenBody(movieId: movieId),
    );
  }
}

class _MovieDetailsScreenBody extends StatelessWidget {
  const _MovieDetailsScreenBody({required this.movieId});

  final int movieId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ScrollConfiguration(
        behavior: _NoGlowScrollBehavior(),
        child: BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
          builder: (context, state) => switch (state) {
            MovieDetailsLoading() => const SingleChildScrollView(
              child: MovieDetailsLoadingView(),
            ),
            MovieDetailsError() => Center(
              child: MovieListErrorView(
                onRetry: () => context.read<MovieDetailsCubit>().load(movieId),
              ),
            ),
            MovieDetailsSuccess(:final details, :final suggestions) =>
              _MovieDetailsContent(details: details, suggestions: suggestions),
          },
        ),
      ),
    );
  }
}

class _NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;
}

class _MovieDetailsContent extends StatelessWidget {
  const _MovieDetailsContent({
    required this.details,
    required this.suggestions,
  });

  final MovieDetailsEntity details;
  final List<RelatedMovieEntity> suggestions;

  @override
  Widget build(BuildContext context) {
    final wishlistItem = WishlistItem(
      movieId: details.id,
      title: details.title,
      posterUrl: details.posterUrl,
      rating: details.rating,
    );

    return BlocProvider<FavoriteCubit>(
      create: (_) => getIt<FavoriteCubit>()..load(wishlistItem),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: BlocBuilder<FavoriteCubit, FavoriteState>(
              builder: (context, state) => HeroMovieHeader(
                backdropUrl: details.backdropUrl,
                isFavorite: state is FavoriteLoaded && state.isFavorite,
                onBackTap: () => context.pop(),
                onBookmarkTap: () =>
                    context.read<FavoriteCubit>().toggle(wishlistItem),
              ),
            ),
          ),
          _SliverSection(child: _MovieInfo(details: details)),
          if (details.screenshotUrls.isNotEmpty) ...[
            _SliverSection(
              topSpacing: AppSpacing.xl,
              child: SectionTitle(title: context.l10n.screenShots),
            ),
            SliverPadding(
              padding: EdgeInsetsDirectional.only(top: AppSpacing.md),
              sliver: SliverToBoxAdapter(
                child: _ScreenshotsRow(screenshotUrls: details.screenshotUrls),
              ),
            ),
          ],
          _SliverSection(
            topSpacing: AppSpacing.xl,
            child: _SummarySection(summary: details.summary),
          ),
          if (details.cast.isNotEmpty)
            _SliverSection(
              topSpacing: AppSpacing.xl,
              child: _CastSection(cast: details.cast),
            ),
          if (details.genres.isNotEmpty)
            _SliverSection(
              topSpacing: AppSpacing.xl,
              child: _GenresSection(genres: details.genres),
            ),
          if (suggestions.isNotEmpty) ...[
            _SliverSection(
              topSpacing: AppSpacing.xl,
              child: SectionTitle(title: context.l10n.similar),
            ),
            SliverPadding(
              padding: EdgeInsetsDirectional.only(top: AppSpacing.md),
              sliver: SliverToBoxAdapter(
                child: SuggestionsRow(movies: suggestions),
              ),
            ),
          ],
          SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
        ],
      ),
    );
  }
}

class _SliverSection extends StatelessWidget {
  const _SliverSection({required this.child, this.topSpacing});

  final Widget child;
  final double? topSpacing;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.screenPadding,
      ).copyWith(top: topSpacing ?? 0),
      sliver: SliverToBoxAdapter(child: child),
    );
  }
}

class _MovieInfo extends StatelessWidget {
  const _MovieInfo({required this.details});

  final MovieDetailsEntity details;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: AppSpacing.lg),
        Text(
          details.title,
          textAlign: TextAlign.center,
          style: context.textTheme.titleMedium,
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          details.year.toString(),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        PrimaryWatchButton(label: context.l10n.watch),
        SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: MetricChip(
                icon: Icons.favorite_rounded,
                value: details.likeCount.toString(),
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: MetricChip(
                icon: Icons.access_time_filled_rounded,
                value: details.runtimeMinutes.toString(),
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: MetricChip(
                icon: Icons.star_rounded,
                value: details.rating.toStringAsFixed(1),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ScreenshotsRow extends StatelessWidget {
  const _ScreenshotsRow({required this.screenshotUrls});

  final List<String> screenshotUrls;

  static const double _heightDesignPx = 110;
  static const double _widthDesignPx = 200;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _heightDesignPx.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        itemCount: screenshotUrls.length,
        separatorBuilder: (_, _) => SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) => ScreenshotCard(
          imageUrl: screenshotUrls[index],
          width: _widthDesignPx.w,
        ),
      ),
    );
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({required this.summary});

  final String summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: context.l10n.summary),
        SizedBox(height: AppSpacing.md),
        Text(
          summary,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class _CastSection extends StatelessWidget {
  const _CastSection({required this.cast});

  final List<CastMemberEntity> cast;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: context.l10n.cast),
        SizedBox(height: AppSpacing.md),
        for (final member in cast) ...[
          CastMemberCard(
            avatarUrl: member.avatarUrl,
            name: member.name,
            character: member.character,
          ),
          if (member != cast.last) SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _GenresSection extends StatelessWidget {
  const _GenresSection({required this.genres});

  final List<String> genres;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: context.l10n.genres),
        SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [for (final genre in genres) GenreChip(label: genre)],
        ),
      ],
    );
  }
}
