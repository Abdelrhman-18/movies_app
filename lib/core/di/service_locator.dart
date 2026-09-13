import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:movies_app/core/network/api_client.dart';
import 'package:movies_app/core/network/dio_factory.dart';

import 'package:movies_app/features/auth/data/repositories/auth_repository.dart';
import 'package:movies_app/features/auth/data/repositories/auth_repository_impl.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt
    ..registerLazySingleton<Dio>(DioFactory.create)
    ..registerFactory<ProfileCubit>(
          () => ProfileCubit(getIt<AuthRepository>()),
    )
    ..registerLazySingleton<ApiClient>(() => ApiClient(getIt<Dio>()))
    ..registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(),
    );
}