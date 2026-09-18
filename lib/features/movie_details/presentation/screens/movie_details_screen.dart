import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_text_styles.dart';
import 'package:movies_app/core/theme/app_theme.dart';

import 'package:movies_app/features/movie_details/domain/entities/wishlist_item.dart';
import 'package:movies_app/features/movie_details/presentation/cubit/favorite_cubit.dart';
import 'package:movies_app/features/movie_details/presentation/cubit/favorite_state.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/cast_member_card.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/genre_chip.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/hero_movie_header.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/metric_chip.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/primary_watch_button.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/screenshot_card.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/section_title.dart';

typedef _MockCastMember = ({String name, String character, String avatarUrl});

// TODO(phase-2): replace all mock data below with a real MovieDetails
// entity loaded via a details use case/repository.
class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({super.key});

  static const String _mockBackdropUrl = '';
  static const String _mockTitle =
      'Doctor Strange in the Multiverse of Madness';
  static const String _mockYear = '2022';
  static const String _mockLikes = '15';
  static const String _mockDurationMinutes = '90';
  static const String _mockRating = '7.6';

  static const String _mockSummary =
      'Doctor Strange teams up with a mysterious teenage girl who can travel '
      'across the multiverse to confront a growing threat from an alternate '
      'reality. As new allies and old foes emerge, the journey pulls Strange '
      'deeper into a fractured universe where the rules of magic no longer '
      'hold, forcing him to face a darker side of his own power.';

  static const List<double> _mockScreenshotWidths = [280, 160, 160, 160];
  static const List<String> _mockScreenshots = ['', '', '', ''];

  static const List<_MockCastMember> _mockCast = [
    (name: 'Hayley Atwell', character: 'Captain Carter', avatarUrl: ''),
    (name: 'Benedict Cumberbatch', character: 'Doctor Strange', avatarUrl: ''),
    (name: 'Elizabeth Olsen', character: 'Wanda Maximoff', avatarUrl: ''),
    (name: 'Chiwetel Ejiofor', character: 'Karl Mordo', avatarUrl: ''),
  ];

  static const List<String> _mockGenres = [
    'Action',
    'Sci-Fi',
    'Adventure',
    'Fantasy',
    'Horror',
  ];

  static const WishlistItem _mockMovie = WishlistItem(
    movieId: 76341,
    title: _mockTitle,
    posterUrl: _mockBackdropUrl,
    rating: 7.6,
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoriteCubit>(
      create: (_) => getIt<FavoriteCubit>()..load(_mockMovie),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: BlocBuilder<FavoriteCubit, FavoriteState>(
                builder: (context, state) => HeroMovieHeader(
                  backdropUrl: _mockBackdropUrl,
                  isFavorite: state is FavoriteLoaded && state.isFavorite,
                  onBookmarkTap: () =>
                      context.read<FavoriteCubit>().toggle(_mockMovie),
                ),
              ),
            ),
            _SliverSection(child: const _MovieInfo()),
            _SliverSection(
              topSpacing: AppSpacing.xl,
              child: SectionTitle(title: context.l10n.screenShots),
            ),
            SliverPadding(
              padding: EdgeInsetsDirectional.only(top: AppSpacing.md),
              sliver: const SliverToBoxAdapter(child: _ScreenshotsRow()),
            ),
            _SliverSection(
              topSpacing: AppSpacing.xl,
              child: const _SummarySection(),
            ),
            _SliverSection(
              topSpacing: AppSpacing.xl,
              child: const _CastSection(),
            ),
            _SliverSection(
              topSpacing: AppSpacing.xl,
              bottomSpacing: AppSpacing.xl,
              child: const _GenresSection(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverSection extends StatelessWidget {
  const _SliverSection({
    required this.child,
    this.topSpacing,
    this.bottomSpacing,
  });

  final Widget child;
  final double? topSpacing;
  final double? bottomSpacing;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.screenPadding,
      ).copyWith(top: topSpacing ?? 0, bottom: bottomSpacing ?? 0),
      sliver: SliverToBoxAdapter(child: child),
    );
  }
}

class _MovieInfo extends StatelessWidget {
  const _MovieInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: AppSpacing.lg),
        Text(
          MovieDetailsScreen._mockTitle,
          textAlign: TextAlign.center,
          style: context.textTheme.titleMedium,
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          MovieDetailsScreen._mockYear,
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
                value: MovieDetailsScreen._mockLikes,
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: MetricChip(
                icon: Icons.access_time_filled_rounded,
                value: MovieDetailsScreen._mockDurationMinutes,
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: MetricChip(
                icon: Icons.star_rounded,
                value: MovieDetailsScreen._mockRating,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ScreenshotsRow extends StatelessWidget {
  const _ScreenshotsRow();

  static const double _heightDesignPx = 110;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _heightDesignPx.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        itemCount: MovieDetailsScreen._mockScreenshots.length,
        separatorBuilder: (_, _) => SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) => ScreenshotCard(
          imageUrl: MovieDetailsScreen._mockScreenshots[index],
          width: MovieDetailsScreen._mockScreenshotWidths[index].w,
        ),
      ),
    );
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: context.l10n.summary),
        SizedBox(height: AppSpacing.md),
        Text(
          MovieDetailsScreen._mockSummary,
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
  const _CastSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: context.l10n.cast),
        SizedBox(height: AppSpacing.md),
        for (final member in MovieDetailsScreen._mockCast) ...[
          CastMemberCard(
            avatarUrl: member.avatarUrl,
            name: member.name,
            character: member.character,
          ),
          if (member != MovieDetailsScreen._mockCast.last)
            SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _GenresSection extends StatelessWidget {
  const _GenresSection();

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
          children: [
            for (final genre in MovieDetailsScreen._mockGenres)
              GenreChip(label: genre),
          ],
        ),
      ],
    );
  }
}
