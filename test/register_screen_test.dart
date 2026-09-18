import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movies_app/core/constants/app_assets.dart';
import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/localization/locale_cubit.dart';
import 'package:movies_app/core/theme/app_theme.dart';
import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:movies_app/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:movies_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:movies_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:movies_app/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:movies_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:movies_app/features/auth/presentation/screens/register_screen.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository authRepository;

  setUp(() {
    authRepository = _MockAuthRepository();
    getIt.registerFactory<AuthCubit>(
      () => AuthCubit(
        LoginUseCase(authRepository),
        RegisterUseCase(authRepository),
        GoogleSignInUseCase(authRepository),
        SignOutUseCase(authRepository),
      ),
    );
  });

  tearDown(getIt.reset);

  Future<void> mount(
    WidgetTester tester, {
    Size size = const Size(430, 932),
  }) async {
    rootBundle.clear();
    final fonts = FontLoader('Roboto')
      ..addFont(rootBundle.load('assets/fonts/Roboto-Variable.ttf'));
    await fonts.load();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => LocaleCubit(),
        child: ScreenUtilInit(
          designSize: const Size(430, 932),
          minTextAdapt: true,
          builder: (_, _) => BlocBuilder<LocaleCubit, Locale>(
            builder: (_, locale) => MaterialApp(
              locale: locale,
              theme: AppTheme.dark,
              supportedLocales: AppL10n.supportedLocales,
              localizationsDelegates: AppL10n.delegates,
              home: const RegisterScreen(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'renders compact layout and switches to Arabic without overflow',
    (tester) async {
      await mount(tester, size: const Size(280, 615));
      expect(find.text('Register'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(5));
      expect(tester.takeException(), isNull);
      if (const bool.fromEnvironment('REGISTER_CAPTURE')) {
        await tester.runAsync(() async {
          final context = tester.element(find.byType(RegisterScreen));
          await Future.wait(
            AppAssets.avatars.map(
              (path) => precacheImage(AssetImage(path), context),
            ),
          );
        });
        await tester.pumpAndSettle();
        await expectLater(
          find.byType(RegisterScreen),
          matchesGoldenFile('../build/register-preview.png'),
        );
      }
      await tester.tap(find.bySemanticsLabel('AR'));
      await tester.pumpAndSettle();
      expect(find.text('التسجيل'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.byType(RegisterScreen))),
        TextDirection.rtl,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'validates required fields, password match and valid submission',
    (tester) async {
      when(
        () => authRepository.register(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
          phone: any(named: 'phone'),
        ),
      ).thenAnswer((_) async => const Success(null));

      await mount(tester);
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();
      expect(find.text('This field is required'), findsNWidgets(5));
      final fields = find.byType(TextFormField);
      for (final entry in [
        'Alex',
        'alex@example.com',
        'secret123',
        'different',
        '+201012345678',
      ].asMap().entries) {
        await tester.enterText(fields.at(entry.key), entry.value);
      }
      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();
      expect(find.text('Passwords do not match'), findsOneWidget);
      await tester.enterText(fields.at(3), 'secret123');
      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();
      expect(find.text('Account created successfully'), findsOneWidget);
    },
  );

  testWidgets(
    'password visibility is independent and avatar selection changes',
    (tester) async {
      await mount(tester);
      await tester.tap(find.byIcon(Icons.visibility_off).first);
      await tester.pump();
      final fields = tester
          .widgetList<TextField>(find.byType(TextField))
          .toList();
      expect(fields[2].obscureText, isFalse);
      expect(fields[3].obscureText, isTrue);
      await tester.drag(find.byType(PageView), const Offset(-180, 0));
      await tester.pumpAndSettle();
      expect(
        tester.widget<PageView>(find.byType(PageView)).controller!.page,
        8,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
