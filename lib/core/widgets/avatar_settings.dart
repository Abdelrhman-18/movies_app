import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/constants/app_assets.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_radius.dart';
import 'package:movies_app/core/theme/app_spacing.dart';

class AvatarSettings extends StatefulWidget {
  final int? selectedAvatar;
  final Function(int) onAvatarSelected;
  const AvatarSettings({super.key ,this.selectedAvatar,
    required this.onAvatarSelected,});

  @override
  State<AvatarSettings> createState() => _AvatarSettingsState();
}

class _AvatarSettingsState extends State<AvatarSettings> {
  int? selectedAvatar;
  @override
  void initState() {
    super.initState();
    selectedAvatar = widget.selectedAvatar;
  }
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: AppAssets.avatars.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppSizes.gridWidth,
        mainAxisSpacing: AppSizes.between,

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
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              borderRadius: AppRadius.large,
              color: selectedAvatar == index
                  ? AppColors.primary.withValues(alpha: 0.56)
                  : Colors.transparent,
              border: BoxBorder.all(color: AppColors.primary),
            ),
            child: CircleAvatar(
              radius: AppSizes.gridRaduis,
              backgroundImage: AssetImage(AppAssets.avatars[index]),
            ),
          ),
        );
      },
    );
  }
}
