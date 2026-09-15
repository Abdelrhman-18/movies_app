import 'package:flutter/material.dart';

import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_radius.dart';
import 'package:movies_app/core/theme/app_spacing.dart';

import 'package:movies_app/app/widgets/bottom_nav_item.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final destinations = [
      (icon: Icons.home_rounded, label: context.l10n.home),
      (icon: Icons.search_rounded, label: context.l10n.search),
      (icon: Icons.video_library_rounded, label: context.l10n.browse),
      (icon: Icons.person_rounded, label: context.l10n.profile),
    ];

    return Padding(
      padding: EdgeInsetsDirectional.all(AppSizes.navBarMargin),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.large,
        ),
        child: SizedBox(
          height: AppSizes.navBarHeight,
          child: Row(
            children: [
              for (var i = 0; i < destinations.length; i++)
                BottomNavItem(
                  icon: destinations[i].icon,
                  semanticLabel: destinations[i].label,
                  isActive: i == currentIndex,
                  onTap: () => onTap(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
