import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/localization/locale_cubit.dart';
import 'package:movies_app/core/routing/app_router.dart';
import 'package:movies_app/core/theme/app_theme.dart';

void main() {
  runApp(const MoviesApp());
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocaleCubit>(
      create: (_) => LocaleCubit(),
      child: ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, _) => BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            onGenerateTitle: (context) => context.l10n.appTitle,
            locale: locale,
            localizationsDelegates: AppL10n.delegates,
            supportedLocales: AppL10n.supportedLocales,
            theme: AppTheme.dark,
            routerConfig: AppRouter.router,
          ),
        ),
      ),
    );
  }
}
