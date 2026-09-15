import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:movies_app/core/network/api_client.dart';
import 'package:movies_app/core/network/dio_factory.dart';

import 'package:movies_app/core/movies/data/datasources/movies_remote_data_source.dart';
import 'package:movies_app/core/movies/data/repos/movies_repository_impl.dart';
import 'package:movies_app/core/movies/domain/repos/movies_repository.dart';
import 'package:movies_app/core/movies/domain/usecases/get_movies_usecase.dart';
import 'package:movies_app/features/browse/presentation/controllers/browse_cubit.dart';
import 'package:movies_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:movies_app/features/search/presentation/controllers/search_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt
    ..registerLazySingleton<Dio>(DioFactory.create)
    ..registerLazySingleton<ApiClient>(() => ApiClient(getIt<Dio>()))
    ..registerLazySingleton<MoviesRemoteDataSource>(
      () => MoviesRemoteDataSource(getIt<ApiClient>()),
    )
    ..registerLazySingleton<MoviesRepository>(
      () => MoviesRepositoryImpl(getIt<MoviesRemoteDataSource>()),
    )
    ..registerLazySingleton<GetMoviesUseCase>(
      () => GetMoviesUseCase(getIt<MoviesRepository>()),
    )
    ..registerFactory<HomeCubit>(() => HomeCubit(getIt<GetMoviesUseCase>()))
    ..registerFactory<BrowseCubit>(() => BrowseCubit(getIt<GetMoviesUseCase>()))
    ..registerFactory<SearchCubit>(
      () => SearchCubit(getIt<GetMoviesUseCase>()),
    );
}
