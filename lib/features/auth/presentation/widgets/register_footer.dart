import 'package:flutter/material.dart';

import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_text_styles.dart';
import 'package:movies_app/core/widgets/language_switch.dart';

class RegisterFooter extends StatelessWidget {
  const RegisterFooter({required this.onLogin, super.key});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: onLogin,
          child: Text.rich(
            TextSpan(
              text: '${context.l10n.alreadyHaveAccount} ',
              style: AppTextStyles.bodySmall,
              children: [
                TextSpan(
                  text: context.l10n.login,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        const LanguageSwitch(),
      ],
    );
  }
}
