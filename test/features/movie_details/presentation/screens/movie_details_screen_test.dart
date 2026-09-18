import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/movie_details/domain/entities/wishlist_item.dart';
import 'package:movies_app/features/movie_details/domain/repos/movie_activity_repository.dart';
import 'package:movies_app/features/movie_details/domain/usecases/add_to_wishlist_usecase.dart';
import 'package:movies_app/features/movie_details/domain/usecases/check_is_favorite_usecase.dart';
import 'package:movies_app/features/movie_details/domain/usecases/record_movie_history_usecase.dart';
import 'package:movies_app/features/movie_details/domain/usecases/remove_from_wishlist_usecase.dart';
import 'package:movies_app/features/movie_details/presentation/cubit/favorite_cubit.dart';
import 'package:movies_app/features/movie_details/presentation/screens/movie_details_screen.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/genre_chip.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/metric_chip.dart';

class _FakeMovieActivityRepository implements MovieActivityRepository {
  @override
  Future<AppResult<bool>> isFavorite(int movieId) async => const Success(false);

  @override
  Future<AppResult<void>> addToWishlist(WishlistItem movie) async =>
      const Success(null);

  @override
  Future<AppResult<void>> removeFromWishlist(int movieId) async =>
      const Success(null);

  @override
  Future<AppResult<void>> recordHistory(WishlistItem movie) async =>
      const Success(null);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        pathProviderChannel,
        (call) async => Directory.systemTemp.path,
      );

  setUp(() {
    final repository = _FakeMovieActivityRepository();
    getIt.registerFactory<FavoriteCubit>(
      () => FavoriteCubit(
        CheckIsFavoriteUseCase(repository),
        AddToWishlistUseCase(repository),
        RemoveFromWishlistUseCase(repository),
        RecordMovieHistoryUseCase(repository),
      ),
    );
  });

  tearDown(getIt.reset);

  Future<void> pumpScreen(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(430, 932);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(430, 932),
        builder: (_, _) => MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppL10n.delegates,
          supportedLocales: AppL10n.supportedLocales,
          home: const MovieDetailsScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  testWidgets('renders the title, watch button, and metric chips', (
    tester,
  ) async {
    await pumpScreen(tester);

    expect(
      find.text('Doctor Strange in the Multiverse of Madness'),
      findsOneWidget,
    );
    expect(find.text('2022'), findsOneWidget);
    expect(find.text('Watch'), findsOneWidget);
    expect(find.byType(MetricChip), findsNWidgets(3));
    expect(find.text('15'), findsOneWidget);
    expect(find.text('90'), findsOneWidget);
    expect(find.text('7.6'), findsOneWidget);
  });

  testWidgets('renders every section title', (tester) async {
    await pumpScreen(tester);

    expect(find.text('Screenshots'), findsOneWidget);
    expect(find.text('Summary'), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -1800));
    await tester.pump();

    expect(find.text('Cast'), findsOneWidget);
    expect(find.text('Genres'), findsOneWidget);
  });

  testWidgets('renders a genre chip for every mock genre', (tester) async {
    await pumpScreen(tester);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -1800));
    await tester.pump();

    for (final genre in [
      'Action',
      'Sci-Fi',
      'Adventure',
      'Fantasy',
      'Horror',
    ]) {
      expect(find.widgetWithText(GenreChip, genre), findsOneWidget);
    }
  });
}
