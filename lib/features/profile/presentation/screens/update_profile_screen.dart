import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_text_styles.dart';
import 'package:movies_app/core/widgets/app_app_bar.dart';
import 'package:movies_app/core/widgets/app_button.dart';

import 'package:movies_app/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:movies_app/features/profile/presentation/cubit/profile/profile_state.dart';
import 'package:movies_app/features/profile/presentation/widgets/profile_avatar_picker.dart';
import 'package:movies_app/features/profile/presentation/widgets/profile_info_fields.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
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
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppAppBar(title: context.l10n.editProfile),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.all(AppSpacing.screenPadding),
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
                    onPressed: () =>
                        context.pushNamed(AppRoutes.forgotPasswordName),
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
                  // TODO(phase-2): Dispatch account deletion once a
                  // delete-account repository method exists.
                  onPressed: () {},
                ),

                SizedBox(height: AppSpacing.sm),

                AppButton(
                  label: context.l10n.updateData,
                  onPressed: _updateProfile,
                ),

                SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
