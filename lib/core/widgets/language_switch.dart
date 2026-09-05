import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:movies_app/core/constants/app_assets.dart';
import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/localization/locale_cubit.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_radius.dart';
import 'package:movies_app/core/theme/app_spacing.dart';

/// Shared language control; reads and updates [LocaleCubit] itself.
class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) => SizedBox(
        width: AppSizes.languageSwitchWidth,
        height: AppSizes.languageSwitchHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.primary,
              width: AppSizes.categoryBorderWidth,
            ),
            borderRadius: AppRadius.large,
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.all(AppSizes.categoryBorderWidth),
            child: Row(
              textDirection: TextDirection.ltr,
              children: [
                Expanded(
                  child: _FlagOption(
                    flagAsset: AppAssets.usaFlag,
                    semanticLabel: context.l10n.englishShort,
                    isSelected: locale.languageCode == 'en',
                    onTap: () =>
                        context.read<LocaleCubit>().setArabic(isArabic: false),
                  ),
                ),
                Expanded(
                  child: _FlagOption(
                    flagAsset: AppAssets.egyptFlag,
                    semanticLabel: context.l10n.arabicShort,
                    isSelected: locale.languageCode == 'ar',
                    onTap: () =>
                        context.read<LocaleCubit>().setArabic(isArabic: true),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FlagOption extends StatelessWidget {
  const _FlagOption({
    required this.flagAsset,
    required this.semanticLabel,
    required this.isSelected,
    required this.onTap,
  });

  final String flagAsset;
  final String semanticLabel;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.background,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.all(AppSizes.categoryBorderWidth),
              child: SizedBox.square(
                dimension: AppSizes.languageFlag,
                child: ClipOval(
                  child: ExcludeSemantics(
                    child: SvgPicture.asset(flagAsset, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
