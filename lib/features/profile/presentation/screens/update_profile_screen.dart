import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_radius.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_text_styles.dart';
import 'package:movies_app/core/widgets/app_app_bar.dart';
import 'package:movies_app/core/widgets/app_button.dart';

import 'package:movies_app/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:movies_app/features/profile/presentation/cubit/profile/profile_state.dart';
import 'package:movies_app/features/profile/presentation/widgets/delete_account_confirmation_dialog.dart';
import 'package:movies_app/features/profile/presentation/widgets/profile_avatar_picker.dart';
import 'package:movies_app/features/profile/presentation/widgets/profile_info_fields.dart';

import '../../../auth/presentation/screens/reset_password_screen.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  int? _selectedAvatar;
  File? _selectedImage;
  bool _isUserLoaded = false;
  String? _profileImageUrl;
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onAvatarSelected(int index) {
    setState(() {
      _selectedAvatar = index;
      _selectedImage = null;
      _profileImageUrl = null;
    });
  }

  void _onGalleryImageSelected(File file) {
    setState(() {
      _selectedImage = file;
      _selectedAvatar = null;
      _profileImageUrl = null;
    });
  }

  void _updateProfile() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.profileNameAndPhoneRequired)),
      );
      return;
    }

    context.read<ProfileCubit>().updateProfile(
      name: name,
      phone: phone,
      avatarIndex: _selectedAvatar,
      profileImage: _selectedImage,
    );
  }
  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const DeleteAccountConfirmationDialog(),
    );

    if (confirmed != true || !mounted) return;

    context.read<ProfileCubit>().deleteAccount();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUserLoaded && !_isUserLoaded) {
          _isUserLoaded = true;

          _nameController.text = state.user.name;
          _phoneController.text = state.user.phone;

          setState(() {
            _selectedAvatar = state.user.avatarIndex;
            _profileImageUrl = state.user.profileImageUrl;
          });
        }

        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.somethingWentWrong)),
          );
        }

        if (state is ProfileSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.profileUpdatedSuccessfully)),
          );
          if (context.mounted) context.pop();
        }

        if (state is ProfileReauthRequired) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.deleteAccountRequiresRecentLogin),
            ),
          );
        }

        if (state is ProfileAccountDeleted) {
          context.go(AppRoutes.onboardingPath);
        }
      },
      builder: (context, state) {
        final isLoadingInitialUser = !_isUserLoaded && state is! ProfileError;
        final isSubmitting = _isUserLoaded && state is ProfileLoading;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppAppBar(title: context.l10n.editProfile),
          body: SafeArea(
            child: isLoadingInitialUser
                ? const _EditProfileLoadingView()
                : SingleChildScrollView(
                    padding: EdgeInsetsDirectional.all(
                      AppSpacing.screenPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: AppSpacing.xl),

                        Center(
                          child: ProfileAvatarPicker(
                            selectedAvatar: _selectedAvatar,
                            selectedImage: _selectedImage,
                            selectedImageUrl: _profileImageUrl,
                            onAvatarSelected: _onAvatarSelected,
                            onGalleryImageSelected: _onGalleryImageSelected,
                          ),
                        ),

                        SizedBox(height: AppSpacing.xl),

                        ProfileInfoFields(
                          nameController: _nameController,
                          phoneController: _phoneController,
                        ),

                        SizedBox(height: AppSpacing.lg),

                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                       ResetPasswordScreen()
                                ));
                            }
                              ,
                            child: Text(
                              context.l10n.resetPassword,
                              style: AppTextStyles.titleSmall,
                            ),
                          ),
                        ),

                        SizedBox(height: AppSizes.updateProfileIllustration),

                        AppButton(
                          label: context.l10n.deleteAccount,
                          variant: AppButtonVariant.danger,
                          onPressed: _deleteAccount,
                        ),

                        SizedBox(height: AppSpacing.sm),

                        AppButton(
                          label: context.l10n.updateData,
                          isLoading: isSubmitting,
                          onPressed: _updateProfile,
                        ),

                        SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _EditProfileLoadingView extends StatelessWidget {
  const _EditProfileLoadingView();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.textSecondary,
      child: Padding(
        padding: EdgeInsetsDirectional.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: AppSpacing.xl),
            Center(
              child: _block(
                width: AppSizes.profileAvatarPreview,
                height: AppSizes.profileAvatarPreview,
                borderRadius: BorderRadius.circular(
                  AppSizes.profileAvatarPreview / 2,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.xl),
            _block(height: AppSizes.fieldHeight),
            SizedBox(height: AppSpacing.md),
            _block(height: AppSizes.fieldHeight),
            SizedBox(height: AppSpacing.lg),
            _block(height: 20.h, width: 140.w),
            SizedBox(height: AppSpacing.xl),
            _block(height: AppSizes.buttonHeight),
            SizedBox(height: AppSpacing.sm),
            _block(height: AppSizes.buttonHeight),
          ],
        ),
      ),
    );
  }

  Widget _block({double? width, double? height, BorderRadius? borderRadius}) {
    return ClipRRect(
      borderRadius: borderRadius ?? AppRadius.medium,
      child: SizedBox(
        width: width,
        height: height,
        child: const ColoredBox(color: AppColors.surface),
      ),
    );
  }
}
