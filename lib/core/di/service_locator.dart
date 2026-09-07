import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:movies_app/core/network/api_client.dart';
import 'package:movies_app/core/network/dio_factory.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt
    ..registerLazySingleton<Dio>(DioFactory.create)
    ..registerLazySingleton<ApiClient>(() => ApiClient(getIt<Dio>()));
}
