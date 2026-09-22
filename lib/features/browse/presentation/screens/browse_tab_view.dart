import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/widgets/app_chip.dart';
import 'package:movies_app/core/widgets/empty_state.dart';
import 'package:movies_app/core/widgets/movie_list_error_view.dart';
import 'package:movies_app/core/widgets/poster_card.dart';
import 'package:movies_app/core/widgets/poster_grid_shimmer.dart';

import 'package:movies_app/features/browse/presentation/cubit/browse_cubit.dart';
import 'package:movies_app/features/browse/presentation/cubit/browse_state.dart';

class BrowseTabView extends StatelessWidget {
  const BrowseTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BrowseCubit>(
      create: (_) => getIt<BrowseCubit>()..loadMovies(),
      child: const _BrowseTabViewBody(),
    );
  }
}

class _BrowseTabViewBody extends StatelessWidget {
  const _BrowseTabViewBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrowseCubit, BrowseState>(
      builder: (context, state) {
        final genresList = state.genres.toList();

        return CustomScrollView(
          slivers: [
            if (genresList.isNotEmpty)
              SliverPadding(
                padding: EdgeInsetsDirectional.only(
                  top: AppSpacing.md,
                  bottom: AppSpacing.md,
                ),
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    height: AppSizes.genreChipHeight,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: AppSpacing.screenPadding,
                      ),
                      itemCount: genresList.length,
                      separatorBuilder: (_, _) => SizedBox(width: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final genre = genresList[index];
                        return AppChip(
                          label: genre,
                          isSelected: genre == state.selectedGenre,
                          onTap: () =>
                              context.read<BrowseCubit>().selectGenre(genre),
                        );
                      },
                    ),
                  ),
                ),
              ),
            switch (state) {
              BrowseLoading() => const SliverToBoxAdapter(
                child: PosterGridShimmer(),
              ),
              BrowseSuccess(:final movies) => SliverPadding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: PosterCard.aspectRatio,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => PosterCard(
                      posterUrl: movies[index].posterUrl,
                      rating: movies[index].rating,
                    ),
                    childCount: movies.length,
                  ),
                ),
              ),
              BrowseEmpty() => SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyState(message: context.l10n.noResults),
              ),
              BrowseError() => SliverFillRemaining(
                hasScrollBody: false,
                child: MovieListErrorView(
                  onRetry: () => context.read<BrowseCubit>().retry(),
                ),
              ),
            },
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
          ],
        );
      },
    );
  }
}