import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:movies_app/core/constants/app_assets.dart';
import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_radius.dart';
import 'package:movies_app/core/theme/app_spacing.dart';

/// Shared language control; locale state is owned by the caller.
class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({required this.isArabic, required this.onChanged, super.key});

  final bool isArabic;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.primary, width: AppSizes.categoryBorderWidth),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.ltr,
        children: [
          for (final arabic in [false, true])
            Semantics(
              selected: isArabic == arabic,
              child: IconButton(
                tooltip: arabic ? context.l10n.arabicShort : context.l10n.englishShort,
                constraints: BoxConstraints.tightFor(
                  width: AppSizes.languageOptionWidth,
                  height: AppSizes.languageOptionWidth,
                ),
                padding: EdgeInsets.zero,
                style: IconButton.styleFrom(
                  backgroundColor: isArabic == arabic ? AppColors.primary : null,
                ),
                onPressed: () => onChanged(arabic),
                icon: ClipOval(
                  child: SvgPicture.asset(
                    arabic ? AppAssets.egyptFlag : AppAssets.usaFlag,
                    width: AppSizes.languageFlag,
                    height: AppSizes.languageFlag,
                    fit: BoxFit.cover,
                    excludeFromSemantics: true,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
