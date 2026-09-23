import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/theme/app_colors.dart';

import 'package:movies_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:movies_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:movies_app/features/browse/presentation/screens/browse_tab_view.dart';
import 'package:movies_app/features/home/presentation/screens/home_tab_view.dart';
import 'package:movies_app/features/profile/presentation/screens/profile_tab_view.dart';
import 'package:movies_app/features/search/presentation/screens/search_tab_view.dart';

import 'package:movies_app/app/widgets/bottom_nav_bar.dart';

class AppShellScreen extends StatefulWidget {
  const AppShellScreen({super.key});

  @override
  State<AppShellScreen> createState() => _AppShellScreenState();
}

class _AppShellScreenState extends State<AppShellScreen> {
  static const int _profileTab = 3;

  int _tabIndex = 0;

  Future<void> _signOut() async {
    final authCubit = getIt<AuthCubit>();

    try {
      await authCubit.signOut();

      if (authCubit.state case AuthFailure(:final message)) {
        throw Exception(message);
      }
    } finally {
      await authCubit.close();
    }

    if (mounted) context.go(AppRoutes.onboardingPath);
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const HomeTabView(),
      const SearchTabView(),
      const BrowseTabView(),
      ProfileTabView(onLogout: _signOut, isActive: _tabIndex == _profileTab),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _tabIndex, children: tabs),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: BottomNavBar(
          currentIndex: _tabIndex,
          onTap: (index) => setState(() => _tabIndex = index),
        ),
      ),
    );
  }
}
