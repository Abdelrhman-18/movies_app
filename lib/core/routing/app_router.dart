import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/widgets/design_system_showcase_screen.dart';

import 'package:movies_app/features/auth/presentation/screens/login_screen.dart';
import 'package:movies_app/features/auth/presentation/screens/register_screen.dart';
import 'package:movies_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:movies_app/features/movie_details/presentation/screens/movie_details_screen.dart';
import 'package:movies_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:movies_app/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:movies_app/features/profile/presentation/screens/update_profile_screen.dart';

import 'package:movies_app/app/app_shell_screen.dart';

abstract final class AppRouter {
  static const List<String> _publicPaths = [
    AppRoutes.onboardingPath,
    AppRoutes.loginPath,
    AppRoutes.registerPath,
    AppRoutes.forgotPasswordPath,
  ];

  // TODO(phase-2): persist a "seen onboarding" flag (shared_preferences) so
  // a logged-out user who has already seen it lands on login instead.
  static String? _redirect(BuildContext context, GoRouterState state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final isPublicRoute = _publicPaths.contains(state.matchedLocation);

    if (!isLoggedIn && !isPublicRoute) {
      return AppRoutes.onboardingPath;
    }
    if (isLoggedIn && isPublicRoute) {
      return AppRoutes.homePath;
    }
    return null;
  }

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.homePath,
    redirect: _redirect,
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
        name: AppRoutes.updateProfileName,
        path: AppRoutes.updateProfilePath,
        builder: (_, _) => BlocProvider(
          create: (_) => getIt<ProfileCubit>()..getCurrentUser(),
          child: const UpdateProfileScreen(),
        ),
      ),

      GoRoute(
        name: AppRoutes.homeName,
        path: AppRoutes.homePath,
        builder: (_, _) => const AppShellScreen(),
      ),
      GoRoute(
        name: AppRoutes.showcaseName,
        path: AppRoutes.showcasePath,
        builder: (_, _) => const DesignSystemShowcaseScreen(),
      ),
      GoRoute(
        name: AppRoutes.movieDetailsName,
        path: AppRoutes.movieDetailsPath,
        builder: (_, state) =>
            MovieDetailsScreen(movieId: state.extra as int? ?? 0),
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
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: Text(
            message,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
