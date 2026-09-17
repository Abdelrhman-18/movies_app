import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:movies_app/core/constants/app_assets.dart';
import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_theme.dart';
import 'package:movies_app/core/widgets/app_button.dart';
import 'package:movies_app/core/widgets/app_chip.dart';
import 'package:movies_app/core/widgets/empty_state.dart';

import 'package:movies_app/features/profile/presentation/widgets/profile_stat.dart';

class ProfileTabView extends StatefulWidget {
  const ProfileTabView({super.key});

  @override
  State<ProfileTabView> createState() => _ProfileTabViewState();
}

class _ProfileTabViewState extends State<ProfileTabView> {
  static const int _wishListCount = 12;
  static const int _historyCount = 27;
  static const String _mockUsername = 'John Doe';

  int _selectedSegment = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.all(AppSpacing.screenPadding),
      child: Column(
        children: [
          SizedBox(height: AppSpacing.xl),
          ClipOval(
            child: Image.asset(
              AppAssets.avatars.first,
              width: AppSizes.avatar,
              height: AppSizes.avatar,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Text(_mockUsername, style: context.textTheme.titleMedium),
          SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileStat(count: _wishListCount, label: context.l10n.wishList),
              SizedBox(width: AppSpacing.xl),
              ProfileStat(count: _historyCount, label: context.l10n.history),
            ],
          ),
          SizedBox(height: AppSpacing.xl),
          AppButton(
            label: context.l10n.editProfile,
            onPressed: () => context.push(AppRoutes.updateProfilePath),
          ),
          SizedBox(height: AppSpacing.sm),
          AppButton(
            label: context.l10n.logout,
            variant: AppButtonVariant.danger,
            onPressed: () {
              // TODO(phase-2): Dispatch sign-out to the auth Bloc.
            },
          ),
          SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: AppChip(
                  label: context.l10n.wishList,
                  isSelected: _selectedSegment == 0,
                  onTap: () => setState(() => _selectedSegment = 0),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppChip(
                  label: context.l10n.history,
                  isSelected: _selectedSegment == 1,
                  onTap: () => setState(() => _selectedSegment = 1),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xl),
          EmptyState(message: context.l10n.emptyWishList),
        ],
      ),
    );
  }
}
