import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/localization/locale_cubit.dart';
import 'package:movies_app/core/routing/app_router.dart';
import 'package:movies_app/core/theme/app_theme.dart';
import 'package:movies_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initFirebase();
  await configureDependencies();
  runApp(const MoviesApp());
}

Future<void> _initFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error) {
    debugPrint(
      'Firebase init skipped: $error\n'
      'Run `flutterfire configure` to enable auth/Firestore.',
    );
  }
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
