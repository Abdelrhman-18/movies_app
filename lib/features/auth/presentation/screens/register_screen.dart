import 'package:flutter/material.dart';

import 'package:movies_app/core/localization/l10n.dart';

import 'package:go_router/go_router.dart';

import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/widgets/app_app_bar.dart';

import 'package:movies_app/features/auth/presentation/widgets/register_avatar_picker.dart';
import 'package:movies_app/features/auth/presentation/widgets/register_footer.dart';
import 'package:movies_app/features/auth/presentation/widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.registerTitle,
        onBack: () => context.canPop()
            ? context.pop()
            : context.go(AppRoutes.showcasePath),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsetsDirectional.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppSpacing.md),
              const RegisterAvatarPicker(),
              SizedBox(height: AppSpacing.sm),
              const RegisterForm(),
              RegisterFooter(
                onLogin: () => context.canPop()
                    ? context.pop()
                    : context.go(AppRoutes.loginPath),
              ),
              SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
