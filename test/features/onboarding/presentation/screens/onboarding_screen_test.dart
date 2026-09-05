import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/features/onboarding/presentation/screens/onboarding_screen.dart';

void main() {
  testWidgets('moves through all onboarding pages and finishes', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(430, 932);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    var didFinish = false;

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(430, 932),
        builder: (_, _) => MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppL10n.delegates,
          supportedLocales: AppL10n.supportedLocales,
          home: OnboardingScreen(onFinished: () => didFinish = true),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Find Your Next Favorite Movie Here'), findsOneWidget);
    expect(find.text('Back'), findsNothing);

    await tester.tap(find.text('Explore Now'));
    await tester.pumpAndSettle();
    expect(find.text('Discover Movies'), findsOneWidget);
    expect(find.text('Back'), findsNothing);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Explore All Genres'), findsOneWidget);
    expect(find.text('Back'), findsOneWidget);

    for (final title in [
      'Create Watchlists',
      'Rate, Review, and Learn',
      'Start Watching Now',
    ]) {
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text(title), findsOneWidget);
    }

    await tester.tap(find.text('Finish'));
    await tester.pumpAndSettle();
    expect(didFinish, isTrue);
  });
}
