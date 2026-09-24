import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/constants/app_assets.dart';

import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_theme.dart';
import 'package:movies_app/core/widgets/app_text_field.dart';
import 'package:movies_app/core/widgets/empty_state.dart';
import 'package:movies_app/core/widgets/movie_list_error_view.dart';
import 'package:movies_app/core/widgets/poster_card.dart';
import 'package:movies_app/core/widgets/poster_grid_shimmer.dart';

import 'package:movies_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:movies_app/features/search/presentation/cubit/search_state.dart';

class SearchTabView extends StatelessWidget {
  const SearchTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchCubit>(
      create: (_) => getIt<SearchCubit>(),
      child: const _SearchTabViewBody(),
    );
  }
}

class _SearchTabViewBody extends StatefulWidget {
  const _SearchTabViewBody();

  @override
  State<_SearchTabViewBody> createState() => _SearchTabViewBodyState();
}

class _SearchTabViewBodyState extends State<_SearchTabViewBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) => CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsetsDirectional.all(AppSpacing.screenPadding),
            sliver: SliverToBoxAdapter(
              child: AppTextField(
                hint: context.l10n.searchMovies,
                controller: _searchController,
                prefixIcon: Icons.search,
                onChanged: context.read<SearchCubit>().queryChanged,
              ),
            ),
          ),
          switch (state) {
            SearchInitial() => SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyState(
                message: context.l10n.searchPrompt,
                imagePath: AppAssets.emptyIllustration,
              ),
            ),
            SearchLoading() => const SliverToBoxAdapter(
              child: PosterGridShimmer(),
            ),
            SearchSuccess(:final movies) => SliverMainAxisGroup(
              slivers: [
                SliverPadding(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
                        bottom: AppSpacing.md,
                      ),
                      child: Text(
                        context.l10n.moviesFound(movies.length),
                        style: context.textTheme.bodySmall,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
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
                      (context, index) => GestureDetector(
                        onTap: () => context.push(
                          AppRoutes.movieDetailsPath,
                          extra: movies[index].id,
                        ),
                        child: PosterCard(
                          posterUrl: movies[index].posterUrl,
                          rating: movies[index].rating,
                        ),
                      ),
                      childCount: movies.length,
                    ),
                  ),
                ),
              ],
            ),
            SearchEmpty() => SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyState(message: context.l10n.noResults),
            ),
            SearchError() => SliverFillRemaining(
              hasScrollBody: false,
              child: MovieListErrorView(
                onRetry: () => context.read<SearchCubit>().queryChanged(
                  _searchController.text,
                ),
              ),
            ),
          },
          SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
        ],
      ),
    );
  }
}
