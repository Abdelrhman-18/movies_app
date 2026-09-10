import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_theme.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({required this.title, this.onBack, super.key});

  final String title;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => Size.fromHeight(AppSizes.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: AppSizes.appBarHeight,
      leadingWidth: AppSizes.appBarLeadingWidth,
      leading: IconButton(
        onPressed:
            onBack ??
            () {
              if (context.canPop()) {
                context.pop();
              }
            },
        color: AppColors.primary,
        iconSize: AppSizes.iconSmall,
        icon: const BackButtonIcon(),
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.bodyMedium?.copyWith(color: AppColors.primary),
      ),
      centerTitle: true,
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
    );
  }
}
