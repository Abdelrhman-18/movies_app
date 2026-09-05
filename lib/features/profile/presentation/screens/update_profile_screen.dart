import 'package:flutter/material.dart';

import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_text_styles.dart';
import 'package:movies_app/core/widgets/app_app_bar.dart';
import 'package:movies_app/core/widgets/app_button.dart';

import 'package:movies_app/features/profile/presentation/widgets/profile_avatar_picker.dart';
import 'package:movies_app/features/profile/presentation/widgets/profile_info_fields.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: context.l10n.editProfile),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppSpacing.xl),
              const Center(child: ProfileAvatarPicker()),
              SizedBox(height: AppSpacing.xl),
              const ProfileInfoFields(),
              SizedBox(height: AppSpacing.lg),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  onPressed: () {
                    // TODO(phase-2): Wire the reset-password flow to the auth Bloc.
                  },
                  child: Text(
                    context.l10n.resetPassword,
                    style: AppTextStyles.titleSmall,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              AppButton(
                label: context.l10n.deleteAccount,
                variant: AppButtonVariant.danger,
                onPressed: () {
                  // TODO(phase-2): Dispatch account deletion to the auth Bloc.
                },
              ),
              SizedBox(height: AppSpacing.sm),
              AppButton(
                label: context.l10n.updateData,
                onPressed: () {
                  // TODO(phase-2): Dispatch the profile update to a Profile Bloc.
                },
              ),
              SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
