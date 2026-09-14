import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:movies_app/core/network/api_client.dart';
import 'package:movies_app/core/network/dio_factory.dart';

import 'package:movies_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:movies_app/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:movies_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';

import 'package:movies_app/features/profile/presentation/cubit/profile_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt
    ..registerLazySingleton<Dio>(
      DioFactory.create,
    )
    ..registerLazySingleton<ApiClient>(
          () => ApiClient(getIt<Dio>()),
    )
    ..registerLazySingleton<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceImpl(),
    )
    ..registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(
        remoteDataSource: getIt<AuthRemoteDataSource>(),
      ),
    )
    ..registerFactory<ProfileCubit>(
          () => ProfileCubit(getIt<AuthRepository>()),
    );
}