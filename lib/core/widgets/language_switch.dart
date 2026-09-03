import 'package:flutter/material.dart';

import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_radius.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_theme.dart';

/// Two-option language toggle used on OnBoarding, Login and Profile.
///
/// TODO(design): the Figma shows two flag icons. Swap the short labels for
/// `SvgPicture.asset` once the flag assets land in `AppAssets`.
class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({
    required this.isArabic,
    required this.onChanged,
    super.key,
  });

  final bool isArabic;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.all(AppSpacing.xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LanguageOption(
              label: context.l10n.englishShort,
              isSelected: !isArabic,
              onTap: () => onChanged(false),
            ),
            SizedBox(width: AppSpacing.xs),
            _LanguageOption(
              label: context.l10n.arabicShort,
              isSelected: isArabic,
              onTap: () => onChanged(true),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.small,
      child: SizedBox(
        width: AppSizes.languageOptionWidth,
        height: AppSizes.languageOptionWidth,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: AppRadius.small,
          ),
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? AppColors.primaryText
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
