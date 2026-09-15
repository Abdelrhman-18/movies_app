import 'package:flutter/material.dart';

import 'package:movies_app/core/theme/app_colors.dart';

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
  int _tabIndex = 0;

  static const List<Widget> _tabs = [
    HomeTabView(),
    SearchTabView(),
    BrowseTabView(),
    ProfileTabView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _tabIndex, children: _tabs),
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
