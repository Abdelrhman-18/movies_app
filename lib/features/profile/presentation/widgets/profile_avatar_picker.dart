import 'dart:io';

import 'package:flutter/material.dart';

import 'package:movies_app/core/constants/app_assets.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_spacing.dart';

import 'package:movies_app/features/profile/presentation/widgets/avatar_grid_picker.dart';

class ProfileAvatarPicker extends StatelessWidget {
  const ProfileAvatarPicker({
    super.key,
    required this.selectedAvatar,
    required this.selectedImage,
    required this.onAvatarSelected,
    required this.onGalleryImageSelected,
    this.selectedImageUrl,
  });

  final int? selectedAvatar;
  final File? selectedImage;
  final String? selectedImageUrl;

  final ValueChanged<int> onAvatarSelected;
  final ValueChanged<File> onGalleryImageSelected;

  void _openPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      builder: (_) => SizedBox(
        height: AppSizes.avatarPickerSheetHeight,
        width: double.infinity,
        child: Center(
          child: AvatarGridPicker(
            selectedAvatar: selectedAvatar,
            onAvatarSelected: onAvatarSelected,
            onGalleryImageSelected: onGalleryImageSelected,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPicker(context),
      child: CircleAvatar(
        backgroundColor: AppColors.background,
        radius: AppSizes.profileAvatarPreview / 2,
        child: ClipOval(
          child:  selectedImage != null
        ? Image.file(
        selectedImage!,
          width: AppSizes.profileAvatarPreview,
          height: AppSizes.profileAvatarPreview,
          fit: BoxFit.cover,
        )
            : selectedImageUrl != null && selectedImageUrl!.isNotEmpty
      ? Image.network(
        selectedImageUrl!,
        width: AppSizes.profileAvatarPreview,
        height: AppSizes.profileAvatarPreview,
        fit: BoxFit.cover,
      )
          : Image.asset(
    AppAssets.avatars[selectedAvatar ?? 0],
      width: AppSizes.profileAvatarPreview,
      height: AppSizes.profileAvatarPreview,
      fit: BoxFit.cover,
    ),
        ),
      ),
    );
  }
}