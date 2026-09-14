import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:movies_app/core/network/api_client.dart';
import 'package:movies_app/core/network/dio_factory.dart';

import 'package:movies_app/features/auth/data/datasources/auth_service.dart';
import 'package:movies_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:movies_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:movies_app/features/auth/presentation/cubit/reset_password/reset_password_cubit.dart';
import 'package:movies_app/features/profile/data/datasources/profile_service.dart';
import 'package:movies_app/features/profile/data/repos/profile_repository_impl.dart';
import 'package:movies_app/features/profile/domain/repos/profile_repository.dart';
import 'package:movies_app/features/profile/presentation/cubit/profile/profile_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt
    ..registerLazySingleton<Dio>(DioFactory.create)
    ..registerLazySingleton<ApiClient>(() => ApiClient(getIt<Dio>()))
    ..registerLazySingleton<AuthService>(AuthService.new)
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt<AuthService>()),
    )
    ..registerLazySingleton<ResetPasswordUseCase>(
      () => ResetPasswordUseCase(getIt<AuthRepository>()),
    )
    ..registerFactory<ResetPasswordCubit>(
      () => ResetPasswordCubit(getIt<ResetPasswordUseCase>()),
    )
    ..registerLazySingleton<ProfileService>(ProfileService.new)
    ..registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(getIt<ProfileService>()),
    )
    ..registerFactory<ProfileCubit>(
      () => ProfileCubit(getIt<ProfileRepository>()),
    );
}
