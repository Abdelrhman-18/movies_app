import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:movies_app/core/routing/app_router.dart';
import 'package:movies_app/core/theme/app_theme.dart';

void main() {
  runApp(const MoviesApp());
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Movies App',
        theme: AppTheme.dark,
        routerConfig: AppRouter.router,
      ),
    );
  }
}