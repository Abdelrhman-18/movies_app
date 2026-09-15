import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/movies/data/datasources/movies_remote_data_source.dart';
import 'package:movies_app/core/movies/data/repos/movies_repository_impl.dart';
import 'package:movies_app/core/movies/domain/usecases/get_movies_usecase.dart';
import 'package:movies_app/core/network/api_client.dart';

import 'package:movies_app/features/browse/presentation/controllers/browse_cubit.dart';
import 'package:movies_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:movies_app/features/search/presentation/controllers/search_cubit.dart';

import 'package:movies_app/app/app_shell_screen.dart';

class _StubAdapter implements HttpClientAdapter {
  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      jsonEncode({
        'status': 'ok',
        'status_message': 'Query was successful',
        'data': {
          'movie_count': 2,
          'page_number': 1,
          'movies': [
            {
              'id': 1,
              'title_long': 'Test Movie One (2020)',
              'year': 2020,
              'rating': 7.5,
              'medium_cover_image': 'https://example.com/1.jpg',
              'genres': ['Action'],
            },
            {
              'id': 2,
              'title_long': 'Test Movie Two (2021)',
              'year': 2021,
              'rating': 8.1,
              'medium_cover_image': 'https://example.com/2.jpg',
              'genres': ['Drama'],
            },
          ],
        },
      }),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}

void main() {
  setUp(() {
    final dio = Dio(BaseOptions(baseUrl: 'https://test.example/api/v2/'))
      ..httpClientAdapter = _StubAdapter();
    final repository = MoviesRepositoryImpl(
      MoviesRemoteDataSource(ApiClient(dio)),
    );
    final useCase = GetMoviesUseCase(repository);
    getIt
      ..registerFactory<HomeCubit>(() => HomeCubit(useCase))
      ..registerFactory<BrowseCubit>(() => BrowseCubit(useCase))
      ..registerFactory<SearchCubit>(() => SearchCubit(useCase));
  });

  tearDown(getIt.reset);

  testWidgets(
    'renders the Home tab and switches between all four static tabs',
    (tester) async {
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
            home: const AppShellScreen(),
          ),
        ),
      );
      // Home starts in HomeLoading (Shimmer) while HomeCubit.load() resolves
      // against the stubbed Dio adapter above; avoid pumpAndSettle, Shimmer's
      // animation never settles.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.bySemanticsLabel('Available Now'), findsOneWidget);
      expect(find.bySemanticsLabel('Watch Now'), findsOneWidget);
      expect(find.text('Action'), findsOneWidget);
      expect(find.text('See More'), findsWidgets);

      await tester.tap(find.bySemanticsLabel('Search'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('Search'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Browse'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('Action'), findsWidgets);

      await tester.tap(find.bySemanticsLabel('Profile'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('Exit'), findsOneWidget);
      expect(find.text('Wish List'), findsWidgets);
      expect(find.text('History'), findsWidgets);
    },
  );
}
