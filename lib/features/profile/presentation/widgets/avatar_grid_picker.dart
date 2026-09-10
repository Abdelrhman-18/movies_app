import 'dart:io';

import 'package:flutter/material.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'package:movies_app/core/constants/app_assets.dart';
import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_radius.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_text_styles.dart';

class AvatarGridPicker extends StatefulWidget {
  const AvatarGridPicker({
    required this.onAvatarSelected,
    required this.onGalleryImageSelected,
    this.selectedAvatar,
    super.key,
  });

  final ValueChanged<int> onAvatarSelected;
  final ValueChanged<File> onGalleryImageSelected;
  final int? selectedAvatar;

  @override
  State<AvatarGridPicker> createState() => _AvatarGridPickerState();
}

class _AvatarGridPickerState extends State<AvatarGridPicker> {
  final _picker = ImagePicker();
  late int? _selectedAvatar = widget.selectedAvatar;

  Future<void> _pickFromGallery() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image == null) return;
      widget.onGalleryImageSelected(File(image.path));
    } catch (e) {
      debugPrint('Gallery Error: $e');
    }
  }

  void _selectAvatar(int index) {
    setState(() => _selectedAvatar = index);
    widget.onAvatarSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: AppAssets.avatars.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
            ),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => _selectAvatar(index),
              child: Container(
                padding: EdgeInsetsDirectional.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  borderRadius: AppRadius.large,
                  color: _selectedAvatar == index
                      ? AppColors.primary.withValues(alpha: 0.56)
                      : Colors.transparent,
                  border: Border.all(color: AppColors.primary),
                ),
                child: CircleAvatar(
                  radius: AppSizes.avatarGridItem,
                  backgroundImage: AssetImage(AppAssets.avatars[index]),
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          GestureDetector(
            onTap: _pickFromGallery,
            child: DottedBorder(
              color: AppColors.primary,
              strokeWidth: AppSizes.categoryBorderWidth,
              dashPattern: const [8, 5],
              borderType: BorderType.RRect,
              radius: Radius.circular(20.r),
              child: Container(
                width: double.infinity,
                padding: EdgeInsetsDirectional.symmetric(
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      color: AppColors.primary,
                      size: AppSizes.icon,
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      context.l10n.chooseFromGallery,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
