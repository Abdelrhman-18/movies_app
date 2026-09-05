import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_theme.dart';
import 'package:movies_app/core/widgets/design_system_showcase_screen.dart';

import 'package:movies_app/features/auth/presentation/screens/login_screen.dart';
import 'package:movies_app/features/auth/presentation/screens/register_screen.dart';
import 'package:movies_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:movies_app/features/onboarding/presentation/screens/onboarding_screen.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.onboardingPath,
    routes: [
      GoRoute(
        name: AppRoutes.onboardingName,
        path: AppRoutes.onboardingPath,
        builder: (context, _) =>
            OnboardingScreen(onFinished: () => context.go(AppRoutes.loginPath)),
      ),
      GoRoute(
        name: AppRoutes.loginName,
        path: AppRoutes.loginPath,
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        name: AppRoutes.forgotPasswordName,
        path: AppRoutes.forgotPasswordPath,
        builder: (_, _) => const ResetPasswordScreen(),
      ),
      GoRoute(
        name: AppRoutes.registerName,
        path: AppRoutes.registerPath,
        builder: (_, _) => const RegisterScreen(),
      ),
      GoRoute(
        name: AppRoutes.showcaseName,
        path: AppRoutes.showcasePath,
        builder: (_, _) => const DesignSystemShowcaseScreen(),
      ),
    ],
    errorBuilder: (_, state) => _RouteErrorScreen(
      message: state.error?.toString() ?? state.uri.toString(),
    ),
  );
}

class _RouteErrorScreen extends StatelessWidget {
  const _RouteErrorScreen({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsetsDirectional.all(AppSpacing.screenPadding),
          child: Text(
            message,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
