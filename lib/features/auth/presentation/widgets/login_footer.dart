import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:movies_app/core/constants/app_assets.dart';
import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_text_styles.dart';
import 'package:movies_app/core/widgets/app_button.dart';
import 'package:movies_app/core/widgets/language_switch.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({
    required this.onCreateAccount,
    required this.onGoogleLogin,
    super.key,
  });

  final VoidCallback onCreateAccount;
  final VoidCallback onGoogleLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onCreateAccount,
          child: Text.rich(
            TextSpan(
              text: '${context.l10n.dontHaveAccount} ',
              children: [
                TextSpan(
                  text: context.l10n.createOne,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall,
          ),
        ),
        SizedBox(height: AppSpacing.xl),
        const _SectionDivider(),
        SizedBox(height: AppSpacing.xl),
        AppButton(
          label: context.l10n.loginWithGoogle,
          onPressed: onGoogleLogin,
          icon: SvgPicture.asset(
            AppAssets.googleIcon,
            width: AppSizes.icon,
            height: AppSizes.icon,
          ),
        ),
        SizedBox(height: AppSpacing.xl + AppSpacing.md),
        const LanguageSwitch(),
      ],
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.loginDividerWidth,
      child: Row(
        children: [
          Expanded(
            child: Divider(color: AppColors.primary, endIndent: AppSpacing.sm),
          ),
          Text(
            context.l10n.or,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            child: Divider(color: AppColors.primary, indent: AppSpacing.sm),
          ),
        ],
      ),
    );
  }
}
