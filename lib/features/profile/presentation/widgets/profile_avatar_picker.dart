import 'dart:io';

import 'package:flutter/material.dart';

import 'package:movies_app/core/constants/app_assets.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_spacing.dart';

import 'package:movies_app/features/profile/presentation/widgets/avatar_grid_picker.dart';

class ProfileAvatarPicker extends StatefulWidget {
  const ProfileAvatarPicker({super.key});

  @override
  State<ProfileAvatarPicker> createState() => _ProfileAvatarPickerState();
}

class _ProfileAvatarPickerState extends State<ProfileAvatarPicker> {
  int? _selectedAvatar;
  File? _selectedImage;

  void _openPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      builder: (_) => SizedBox(
        height: AppSizes.avatarPickerSheetHeight,
        width: double.infinity,
        child: Center(
          child: AvatarGridPicker(
            selectedAvatar: _selectedAvatar,
            onAvatarSelected: (index) => setState(() {
              _selectedAvatar = index;
              _selectedImage = null;
            }),
            onGalleryImageSelected: (file) => setState(() {
              _selectedImage = file;
              _selectedAvatar = null;
            }),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openPicker,
      child: CircleAvatar(
        backgroundColor: AppColors.background,
        radius: AppSizes.profileAvatarPreview / 2,
        child: ClipOval(
          child: _selectedImage != null
              ? Image.file(
                  _selectedImage!,
                  width: AppSizes.profileAvatarPreview,
                  height: AppSizes.profileAvatarPreview,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  AppAssets.avatars[_selectedAvatar ?? 0],
                  width: AppSizes.profileAvatarPreview,
                  height: AppSizes.profileAvatarPreview,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
