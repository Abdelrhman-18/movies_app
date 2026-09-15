import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/widgets/empty_state.dart';
import 'package:movies_app/core/widgets/movie_list_error_view.dart';

import 'package:movies_app/features/home/domain/entities/movie_entity.dart';
import 'package:movies_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:movies_app/features/home/presentation/cubit/home_state.dart';
import 'package:movies_app/features/home/presentation/widgets/category_section.dart';
import 'package:movies_app/features/home/presentation/widgets/home_hero_section.dart';
import 'package:movies_app/features/home/presentation/widgets/home_loading_view.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => getIt<HomeCubit>()..load(),
      child: const _HomeTabViewBody(),
    );
  }
}

class _HomeTabViewBody extends StatelessWidget {
  const _HomeTabViewBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) => switch (state) {
        HomeLoading() => const SingleChildScrollView(child: HomeLoadingView()),
        HomeSuccess(:final hero, :final categories) => _HomeContent(
          hero: hero,
          categories: categories,
        ),
        HomeEmpty() => Center(
          child: EmptyState(message: context.l10n.noResults),
        ),
        HomeError() => Center(
          child: MovieListErrorView(
            onRetry: () => context.read<HomeCubit>().load(),
          ),
        ),
      },
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.hero, required this.categories});

  final List<MovieEntity> hero;
  final List<HomeCategory> categories;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: HomeHeroSection(movies: hero)),
        for (final category in categories) ...[
          SliverToBoxAdapter(
            child: CategorySection(
              title: category.title,
              movies: category.movies,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
        ],
      ],
    );
  }
}
