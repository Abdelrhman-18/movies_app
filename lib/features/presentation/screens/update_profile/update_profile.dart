import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies_app/core/constants/app_assets.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_radius.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_text_styles.dart';
import 'package:movies_app/core/widgets/app_app_bar.dart';
import 'package:movies_app/core/widgets/gird_avatar.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  int? selectedAvatar;
  File? selectedImage;
  final ImagePicker picker = ImagePicker();
  Future<void> pickImageFromGallery() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }
  void showAvatarPicker(){


    showModalBottomSheet(context: context,

        backgroundColor: AppColors.background,
        builder: (context){

          return  SizedBox(
            height: 500.h ,
            width: double.infinity,
            child: Center(
              child:
              GirdAvatar(
                selectedAvatar: selectedAvatar,
                onAvatarSelected: (index) {
                  setState(() {
                    selectedAvatar = index;
                    selectedImage = null;

                  });
                },
                onGalleryImageSelected: (file) {
                  setState(() {
                    selectedImage = file;
                    selectedAvatar = null;
                  });
                },
              ),
            ),
          );

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar:AppAppBar( title: "Pick Avatar"),

      // AppBar(
      //   leading: Padding(
      //     padding: EdgeInsets.symmetric(horizontal: 34.w),
      //     child: Icon(
      //       Icons.arrow_back_outlined,
      //       color: AppColors.primary,
      //       size:AppSizes.icon,
      //     ),
      //   ),
      //   title: Text(
      //     "Pick Avatar",
      //     style: TextStyle(
      //       color: AppColors.primary,
      //       fontSize: 14.sp,
      //       fontWeight: FontWeight.w400,
      //       fontFamily: 'Roboto',
      //     ),
      //   ),
      // ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 37.h),

              GestureDetector(
                onTap: showAvatarPicker,
                child: CircleAvatar(
                  backgroundColor: AppColors.background,
                  radius: 75.r,
                  child:  ClipOval(
                child: selectedImage != null
                ? Image.file(
                  selectedImage!,
                  width: 150.w,
                  height: 150.h,
                  fit: BoxFit.cover,
                )
                    : selectedAvatar != null
              ? Image.asset(
              AppAssets.avatars[selectedAvatar!],
                width: 150.w,
                height: 150.h,
                fit: BoxFit.cover,
              )
              : Image.asset(
        AppAssets.avatars[0],
          width: 150.w,
          height: 150.h,
          fit: BoxFit.cover,
        ),
      ),
                ),
              ),

              SizedBox(height: 35.h),

              SizedBox(
                width: double.infinity,
                height: AppSizes.fieldHeight,
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(
                        right: 8.w,
                        left: 18.w,
                        top: 13.h,
                        bottom: 12.72.h,
                      ),
                      child: SvgPicture.asset(
                        AppAssets.userIcon,
                        width: 30.w,
                        height: 30.h,
                      ),
                    ),

                    labelText: "John Safwat",
                    labelStyle: AppTextStyles.titleSmall,

                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppRadius.medium,
                    ),
                  ),
                ),
              ),
              SizedBox(height:AppSizes.between),

              SizedBox(
                width: double.infinity,
                height: AppSizes.fieldHeight,
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(
                        right: 8.w,
                        left: 18.w,
                        top: 13.h,
                        bottom: 12.72.h,
                      ),
                      child: SvgPicture.asset(
                        AppAssets.phoneIcon,
                        width: 25.w,
                        height: 25.h,
                      ),
                    ),

                    labelText: "01200000000",
                    labelStyle: AppTextStyles.titleSmall,

                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppRadius.medium,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSizes.space),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Reset Password",
                    style: AppTextStyles.titleSmall,
                  ),
                ),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                height:AppSizes.buttonHeight,
                child: TextButton(
                  onPressed: () {
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: AppRadius.medium,
                    ),
                    child: Center(
                      child: Text(

                        "Delete Account",
                        style: AppTextStyles.titleSmall
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height:AppSizes.between),

              SizedBox(
                width: double.infinity,
                height: AppSizes.buttonHeight,
                child: TextButton(
                  onPressed: () {
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppRadius.medium,
                    ),
                    child: Center(
                      child: Text(

                          "Update Data",
                          style: AppTextStyles.titleSmall.copyWith(color: AppColors.primaryText)
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSizes.genreChipHeight),




            ],
          ),
        ),
      ),
    );
  }
}