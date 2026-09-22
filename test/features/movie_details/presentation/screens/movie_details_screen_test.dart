import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/error/app_error_model.dart';
import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/movie_details/domain/entities/movie_details_entity.dart';
import 'package:movies_app/features/movie_details/domain/repos/movie_details_repository.dart';
import 'package:movies_app/features/movie_details/domain/usecases/get_movie_details_usecase.dart';
import 'package:movies_app/features/movie_details/domain/usecases/get_movie_suggestions_usecase.dart';
import 'package:movies_app/features/movie_details/presentation/cubit/movie_details_cubit.dart';
import 'package:movies_app/features/movie_details/presentation/screens/movie_details_screen.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/genre_chip.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/metric_chip.dart';

class _MockMovieDetailsRepository extends Mock
    implements MovieDetailsRepository {}

const _movieId = 42;

const _details = MovieDetailsEntity(
  id: _movieId,
  title: 'Doctor Strange in the Multiverse of Madness',
  year: 2022,
  rating: 7.6,
  runtimeMinutes: 90,
  likeCount: 15,
  summary: 'A strange journey across the multiverse.',
  genres: ['Action', 'Sci-Fi'],
  backdropUrl: '',
  posterUrl: '',
  screenshotUrls: [],
  cast: [],
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        pathProviderChannel,
        (call) async => Directory.systemTemp.path,
      );

  late _MockMovieDetailsRepository repository;

  setUp(() {
    repository = _MockMovieDetailsRepository();
    getIt.registerFactory<MovieDetailsCubit>(
      () => MovieDetailsCubit(
        GetMovieDetailsUseCase(repository),
        GetMovieSuggestionsUseCase(repository),
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
          home: const MovieDetailsScreen(movieId: _movieId),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  testWidgets('renders the title, watch button, and metric chips', (
    tester,
  ) async {
    when(
      () => repository.getMovieDetails(_movieId),
    ).thenAnswer((_) async => const Success(_details));
    when(
      () => repository.getMovieSuggestions(_movieId),
    ).thenAnswer((_) async => const Success([]));

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

  testWidgets('renders a genre chip for every genre', (tester) async {
    when(
      () => repository.getMovieDetails(_movieId),
    ).thenAnswer((_) async => const Success(_details));
    when(
      () => repository.getMovieSuggestions(_movieId),
    ).thenAnswer((_) async => const Success([]));

    await pumpScreen(tester);
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -1800));
    await tester.pump();

    for (final genre in ['Action', 'Sci-Fi']) {
      expect(find.widgetWithText(GenreChip, genre), findsOneWidget);
    }
  });

  testWidgets('shows a retry button when loading the movie fails', (
    tester,
  ) async {
    when(() => repository.getMovieDetails(_movieId)).thenAnswer(
      (_) async => const Failure(AppErrorModel(code: 'no-connection')),
    );
    when(
      () => repository.getMovieSuggestions(_movieId),
    ).thenAnswer((_) async => const Success([]));

    await pumpScreen(tester);

    expect(find.text('Retry'), findsOneWidget);
  });
}
