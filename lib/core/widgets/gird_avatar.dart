import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/constants/app_assets.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movies_app/core/theme/app_radius.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
class GirdAvatar extends StatefulWidget {
  final Function(int) onAvatarSelected;
  final Function(File) onGalleryImageSelected;
  final int? selectedAvatar;
  const GirdAvatar({super.key   , required this.onAvatarSelected,
    required this.onGalleryImageSelected,

    this.selectedAvatar,

  });

  @override
  State<GirdAvatar> createState() => _GirdAvatarState();
}

class _GirdAvatarState extends State<GirdAvatar> {
  late int? selectedAvatar;
  @override
  void initState() {
    super.initState();
    selectedAvatar = widget.selectedAvatar;
  }
  File? galleryImage;
  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        final file = File(image.path);

        setState(() {
          galleryImage = file;
        });

        widget.onGalleryImageSelected(file);
      }
    } catch (e) {
      debugPrint("Gallery Error: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(19.0),
      child: Column(
        children: [
      GridView.builder(
      shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: AppAssets.avatars.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: AppSizes.gridWidth,
          mainAxisSpacing: AppSizes.between,
          mainAxisExtent: AppSizes.avatarGrid,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedAvatar = index;
              });

              widget.onAvatarSelected(index);
            },
            child: Container(
              padding: EdgeInsets.only(top: 8,bottom: 10,right: 9,left: 13),
              decoration: BoxDecoration(
                borderRadius: AppRadius.large,
                color: selectedAvatar == index
                    ? AppColors.primary.withValues(alpha: 0.56)
                    : Colors.transparent,
                border: BoxBorder.all(
                  color: AppColors.primary,
                ),
              ),
              child: CircleAvatar(
                radius: AppSizes.gridRaduis,
                backgroundImage: AssetImage(
                  AppAssets.avatars[index],
                ),
              ),
            ),
          );
        },
      ),

        SizedBox(height:AppSizes.height),

          GestureDetector(
            onTap: () {
              pickImageFromGallery();

            },
            child: DottedBorder(
              color: AppColors.primary,
              strokeWidth: 2,
              dashPattern:  [8, 5],
              borderType: BorderType.RRect,
              radius: Radius.circular(20.r),
              child: Container(
                width: 360.w,
                padding: EdgeInsets.symmetric(
                  vertical: 15.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      color: AppColors.primary,
                      size: 31.sp,
                    ),

                    SizedBox(width: AppSpacing.lg),

                    Text(
                      "Choose from Gallery",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 18.sp,
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
