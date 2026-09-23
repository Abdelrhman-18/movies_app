import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:movies_app/core/constants/app_assets.dart';
import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_theme.dart';
import 'package:movies_app/core/widgets/app_button.dart';
import 'package:movies_app/core/widgets/empty_state.dart';
import 'package:movies_app/core/widgets/movie_list_error_view.dart';

import 'package:movies_app/features/profile/domain/entities/wishlist_item.dart';
import 'package:movies_app/features/profile/presentation/cubit/history/history_cubit.dart';
import 'package:movies_app/features/profile/presentation/cubit/history/history_state.dart';
import 'package:movies_app/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:movies_app/features/profile/presentation/cubit/profile/profile_state.dart';
import 'package:movies_app/features/profile/presentation/cubit/wishlist/wishlist_cubit.dart';
import 'package:movies_app/features/profile/presentation/cubit/wishlist/wishlist_state.dart';
import 'package:movies_app/features/profile/presentation/widgets/logout_confirmation_dialog.dart';
import 'package:movies_app/features/profile/presentation/widgets/profile_stat.dart';
import 'package:movies_app/features/profile/presentation/widgets/profile_tab_toggle.dart';
import 'package:movies_app/features/profile/presentation/widgets/wishlist_movies_grid.dart';

class ProfileTabView extends StatefulWidget {
  const ProfileTabView({
    required this.onLogout,
    this.isActive = true,
    super.key,
  });

  final Future<void> Function() onLogout;
  final bool isActive;

  @override
  State<ProfileTabView> createState() => _ProfileTabViewState();
}

class _ProfileTabViewState extends State<ProfileTabView> {
  final ProfileCubit _profileCubit = getIt<ProfileCubit>();
  final WishlistCubit _wishlistCubit = getIt<WishlistCubit>();
  final HistoryCubit _historyCubit = getIt<HistoryCubit>();

  int _selectedSegment = 0;
  bool _isSigningOut = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void didUpdateWidget(covariant ProfileTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) _refresh();
  }

  @override
  void dispose() {
    _profileCubit.close();
    _wishlistCubit.close();
    _historyCubit.close();
    super.dispose();
  }

  void _refresh() {
    _profileCubit.getCurrentUser();
    _wishlistCubit.load();
    _historyCubit.load();
  }

  Future<void> _openEditProfile() async {
    await context.push(AppRoutes.updateProfilePath);
    if (mounted) _refresh();
  }

  Future<void> _openMovie(WishlistItem movie) async {
    await context.push(AppRoutes.movieDetailsPath, extra: movie.movieId);
    if (mounted) _refresh();
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const LogoutConfirmationDialog(),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isSigningOut = true);

    try {
      await widget.onLogout();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.somethingWentWrong)),
        );
      }
    } finally {
      if (mounted) setState(() => _isSigningOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileCubit>.value(value: _profileCubit),
        BlocProvider<WishlistCubit>.value(value: _wishlistCubit),
        BlocProvider<HistoryCubit>.value(value: _historyCubit),
      ],
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _ProfileHeader(
              isSigningOut: _isSigningOut,
              onLogoutTap: _handleLogout,
              onEditProfileTap: _openEditProfile,
            ),
          ),
          SliverToBoxAdapter(
            child: _ProfileTabsRow(
              selectedSegment: _selectedSegment,
              onSegmentSelected: (segment) =>
                  setState(() => _selectedSegment = segment),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
          if (_selectedSegment == 0)
            _WishlistSliver(onMovieTap: _openMovie)
          else
            _HistorySliver(onMovieTap: _openMovie),
          SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.isSigningOut,
    required this.onLogoutTap,
    required this.onEditProfileTap,
  });

  final bool isSigningOut;
  final VoidCallback onLogoutTap;
  final VoidCallback onEditProfileTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.all(AppSpacing.screenPadding),
      child: Column(
        children: [
          SizedBox(height: AppSpacing.xl),
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final user = state is ProfileUserLoaded ? state.user : null;

              return Column(
                children: [
                  ClipOval(
                    child: user?.profileImageUrl?.isNotEmpty ?? false
                        ? Image.network(
                            user!.profileImageUrl!,
                            width: AppSizes.avatar,
                            height: AppSizes.avatar,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            AppAssets.avatars[user?.avatarIndex ?? 0],
                            width: AppSizes.avatar,
                            height: AppSizes.avatar,
                            fit: BoxFit.cover,
                          ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(user?.name ?? '', style: context.textTheme.titleMedium),
                ],
              );
            },
          ),
          SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<WishlistCubit, WishlistState>(
                builder: (context, state) => ProfileStat(
                  count: state is WishlistSuccess ? state.movies.length : 0,
                  label: context.l10n.wishList,
                ),
              ),
              SizedBox(width: AppSpacing.xl),
              BlocBuilder<HistoryCubit, HistoryState>(
                builder: (context, state) => ProfileStat(
                  count: state is HistorySuccess ? state.movies.length : 0,
                  label: context.l10n.history,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xl),
          AppButton(
            label: context.l10n.editProfile,
            onPressed: onEditProfileTap,
          ),
          SizedBox(height: AppSpacing.sm),
          AppButton(
            label: context.l10n.logout,
            variant: AppButtonVariant.danger,
            isLoading: isSigningOut,
            onPressed: onLogoutTap,
          ),
        ],
      ),
    );
  }
}

class _ProfileTabsRow extends StatelessWidget {
  const _ProfileTabsRow({
    required this.selectedSegment,
    required this.onSegmentSelected,
  });

  final int selectedSegment;
  final ValueChanged<int> onSegmentSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: BorderDirectional(bottom: BorderSide(color: AppColors.surface)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ProfileTabToggle(
              icon: Icons.format_list_bulleted_rounded,
              label: context.l10n.wishList,
              isSelected: selectedSegment == 0,
              onTap: () => onSegmentSelected(0),
            ),
          ),
          Expanded(
            child: ProfileTabToggle(
              icon: Icons.folder_rounded,
              label: context.l10n.history,
              isSelected: selectedSegment == 1,
              onTap: () => onSegmentSelected(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _WishlistSliver extends StatelessWidget {
  const _WishlistSliver({required this.onMovieTap});

  final ValueChanged<WishlistItem> onMovieTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistCubit, WishlistState>(
      builder: (context, state) => switch (state) {
        WishlistLoading() => const _SliverLoadingIndicator(),
        WishlistSuccess(:final movies) => WishlistMoviesGrid(
          movies: movies,
          onMovieTap: onMovieTap,
        ),
        WishlistEmpty() => SliverToBoxAdapter(
          child: EmptyState(message: context.l10n.emptyWishList),
        ),
        WishlistError() => SliverToBoxAdapter(
          child: MovieListErrorView(
            onRetry: () => context.read<WishlistCubit>().load(),
          ),
        ),
      },
    );
  }
}

class _HistorySliver extends StatelessWidget {
  const _HistorySliver({required this.onMovieTap});

  final ValueChanged<WishlistItem> onMovieTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) => switch (state) {
        HistoryLoading() => const _SliverLoadingIndicator(),
        HistorySuccess(:final movies) => WishlistMoviesGrid(
          movies: movies,
          onMovieTap: onMovieTap,
        ),
        HistoryEmpty() => SliverToBoxAdapter(
          child: EmptyState(
            message: context.l10n.emptyHistory,
            icon: Icons.history_rounded,
          ),
        ),
        HistoryError() => SliverToBoxAdapter(
          child: MovieListErrorView(
            onRetry: () => context.read<HistoryCubit>().load(),
          ),
        ),
      },
    );
  }
}

class _SliverLoadingIndicator extends StatelessWidget {
  const _SliverLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(vertical: AppSpacing.xl),
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
    );
  }
}
