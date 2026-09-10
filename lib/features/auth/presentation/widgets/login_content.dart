import 'package:flutter/material.dart';

import 'package:movies_app/core/constants/app_assets.dart';
import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_text_styles.dart';
import 'package:movies_app/core/utils/validators.dart';
import 'package:movies_app/core/widgets/app_button.dart';
import 'package:movies_app/core/widgets/app_text_field.dart';

import 'package:movies_app/features/auth/presentation/widgets/login_footer.dart';

class LoginContent extends StatelessWidget {
  const LoginContent({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onLogin,
    required this.onForgotPassword,
    required this.onCreateAccount,
    required this.onGoogleLogin,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;
  final VoidCallback onCreateAccount;
  final VoidCallback onGoogleLogin;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: AppSpacing.xl * 2 + AppSpacing.lg),
          Image.asset(
            AppAssets.appLogo,
            width: AppSizes.loginLogoWidth,
            height: AppSizes.loginLogoHeight,
            fit: BoxFit.contain,
          ),
          SizedBox(height: AppSpacing.xl * 2 + AppSpacing.lg),
          AppTextField(
            hint: context.l10n.email,
            controller: emailController,
            prefixIcon: Icons.email_rounded,
            validator: (value) => Validators.email(context, value),
          ),
          SizedBox(height: AppSpacing.xl),
          AppTextField(
            hint: context.l10n.password,
            controller: passwordController,
            prefixIcon: Icons.lock_rounded,
            isPassword: true,
            validator: (value) => Validators.password(context, value),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Padding(
              padding: EdgeInsetsDirectional.only(top: AppSpacing.sm),
              child: TextButton(
                onPressed: onForgotPassword,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  context.l10n.forgetPassword,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.xl + AppSpacing.sm),
          AppButton(label: context.l10n.login, onPressed: onLogin),
          SizedBox(height: AppSpacing.lg),
          LoginFooter(
            onCreateAccount: onCreateAccount,
            onGoogleLogin: onGoogleLogin,
          ),
          SizedBox(height: AppSpacing.xl + AppSpacing.md),
        ],
      ),
    );
  }
}
