import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_theme.dart';
import 'package:movies_app/features/profile/presentation/screens/update_profile_screen.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.updateProfilePath,
    routes: [
      GoRoute(
        name: AppRoutes.updateProfileName,
        path: AppRoutes.updateProfilePath,
        builder: (_, _) => const UpdateProfileScreen(),
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
