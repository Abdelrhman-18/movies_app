import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/constants/app_assets.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  setState(() {
                    selectedAvatar=0;
                  });
                  widget.onAvatarSelected(0);


                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(20),

                      color: selectedAvatar == 0
                          ? AppColors.primary.withValues(alpha: 0.56)
                          : Colors.transparent,
                    border: BoxBorder.all(color: AppColors.primary)


                  ),
                  child: CircleAvatar(
                    radius:42.r ,
                    backgroundImage: AssetImage(AppAssets.avatars[0]),
                  ),
                ),
              ),
              SizedBox(width: 18.w),
              GestureDetector(
                onTap: (){
                  setState(() {
                    selectedAvatar=1;
                  });
                  widget.onAvatarSelected(1);


                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),

                      color: selectedAvatar == 1
                          ? AppColors.primary.withValues(alpha: 0.56)
                          : Colors.transparent,
                      border: BoxBorder.all(color: AppColors.primary)


                  ),
                  child: CircleAvatar(
                    radius:42.r ,
                    backgroundImage: AssetImage(AppAssets.avatars[1]),
                  ),
                ),
              ),
              SizedBox(width: 18.w),
              GestureDetector(
                onTap: (){
                  setState(() {
                    selectedAvatar=2;
                  });
                  widget.onAvatarSelected(2);


                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),

                      color: selectedAvatar == 2
                          ? AppColors.primary.withValues(alpha: 0.56)
                          : Colors.transparent,
                      border: BoxBorder.all(color: AppColors.primary)


                  ),
                  child: CircleAvatar(
                    radius:42.r ,
                    backgroundImage: AssetImage(AppAssets.avatars[2]),

                  ),
                ),
              ),

            ],
          ),
          SizedBox(height: 19.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  setState(() {
                    selectedAvatar=3;
                  });
                  widget.onAvatarSelected(3);

                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),

                      color: selectedAvatar == 3
                          ? AppColors.primary.withValues(alpha: 0.56)
                          : Colors.transparent,
                      border: BoxBorder.all(color: AppColors.primary)


                  ),
                  child: CircleAvatar(
                    radius:42.r ,
                    backgroundImage: AssetImage(AppAssets.avatars[3]),
                  ),
                ),
              ),
              SizedBox(width: 18.w),
              GestureDetector(
                onTap: (){
                  setState(() {
                    selectedAvatar=4;
                  });
                  widget.onAvatarSelected(4);

                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),

                      color: selectedAvatar == 4
                          ? AppColors.primary.withValues(alpha: 0.56)
                          : Colors.transparent,
                      border: BoxBorder.all(color: AppColors.primary)


                  ),
                  child: CircleAvatar(
                    radius:42.r ,
                    backgroundImage: AssetImage(AppAssets.avatars[4]),
                  ),
                ),
              ),
              SizedBox(width: 18.w),
              GestureDetector(
                onTap: (){
                  setState(() {
                    selectedAvatar=5;
                  });
                  widget.onAvatarSelected(5);

                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),

                      color: selectedAvatar == 5
                          ? AppColors.primary.withValues(alpha: 0.56)
                          : Colors.transparent,
                      border: BoxBorder.all(color: AppColors.primary)


                  ),
                  child: CircleAvatar(
                    radius:42.r ,
                    backgroundImage: AssetImage(AppAssets.avatars[5]),

                  ),
                ),
              ),

            ],
          ),
          SizedBox(height: 19.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  setState(() {
                    selectedAvatar=6;
                  });
                  widget.onAvatarSelected(6);

                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),

                      color: selectedAvatar == 6
                          ? AppColors.primary.withValues(alpha: 0.56)
                          : Colors.transparent,
                      border: BoxBorder.all(color: AppColors.primary)


                  ),
                  child: CircleAvatar(
                    radius:42.r ,
                    backgroundImage: AssetImage(AppAssets.avatars[6]),
                  ),
                ),
              ),
              SizedBox(width: 18.w),
              GestureDetector(
                onTap: (){
                  setState(() {
                    selectedAvatar=7;
                  });
                  widget.onAvatarSelected(7);

                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),

                      color: selectedAvatar == 7
                          ? AppColors.primary.withValues(alpha: 0.56)
                          : Colors.transparent,
                      border: BoxBorder.all(color: AppColors.primary)


                  ),
                  child: CircleAvatar(
                    radius:42.r ,
                    backgroundImage: AssetImage(AppAssets.avatars[7]),
                  ),
                ),
              ),
              SizedBox(width: 18.w),
              GestureDetector(
                onTap: (){
                  setState(() {
                    selectedAvatar=8;
                  });
                  widget.onAvatarSelected(8);

                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),

                      color: selectedAvatar == 8
                          ? AppColors.primary.withValues(alpha: 0.56)
                          : Colors.transparent,
                      border: BoxBorder.all(color: AppColors.primary)


                  ),
                  child: CircleAvatar(
                    radius:42.r ,
                    backgroundImage: AssetImage(AppAssets.avatars[8]),

                  ),
                ),
              ),

            ],
          ),
          SizedBox(height: 25.h),

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

                    SizedBox(width: 12.w),

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
