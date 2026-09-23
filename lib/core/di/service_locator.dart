import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:movies_app/core/network/api_client.dart';
import 'package:movies_app/core/network/dio_factory.dart';

import 'package:movies_app/features/auth/data/datasources/auth_service.dart';
import 'package:movies_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:movies_app/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:movies_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:movies_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:movies_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:movies_app/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:movies_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:movies_app/features/auth/presentation/cubit/reset_password/reset_password_cubit.dart';
import 'package:movies_app/features/browse/presentation/cubit/browse_cubit.dart';
import 'package:movies_app/features/home/data/datasources/movies_remote_data_source.dart';
import 'package:movies_app/features/home/data/repos/movies_repository_impl.dart';
import 'package:movies_app/features/home/domain/repos/movies_repository.dart';
import 'package:movies_app/features/home/domain/usecases/get_movies_usecase.dart';
import 'package:movies_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:movies_app/features/movie_details/data/datasources/movie_activity_service.dart';
import 'package:movies_app/features/movie_details/data/datasources/movie_details_remote_data_source.dart';
import 'package:movies_app/features/movie_details/data/repos/movie_activity_repository_impl.dart';
import 'package:movies_app/features/movie_details/data/repos/movie_details_repository_impl.dart';
import 'package:movies_app/features/movie_details/domain/repos/movie_activity_repository.dart';
import 'package:movies_app/features/movie_details/domain/repos/movie_details_repository.dart';
import 'package:movies_app/features/movie_details/domain/usecases/add_to_wishlist_usecase.dart';
import 'package:movies_app/features/movie_details/domain/usecases/check_is_favorite_usecase.dart';
import 'package:movies_app/features/movie_details/domain/usecases/get_movie_details_usecase.dart';
import 'package:movies_app/features/movie_details/domain/usecases/get_movie_suggestions_usecase.dart';
import 'package:movies_app/features/movie_details/domain/usecases/record_movie_history_usecase.dart';
import 'package:movies_app/features/movie_details/domain/usecases/remove_from_wishlist_usecase.dart';
import 'package:movies_app/features/movie_details/presentation/cubit/favorite_cubit.dart';
import 'package:movies_app/features/movie_details/presentation/cubit/movie_details_cubit.dart';
import 'package:movies_app/features/profile/data/datasources/profile_lists_service.dart';
import 'package:movies_app/features/profile/data/datasources/profile_service.dart';
import 'package:movies_app/features/profile/data/repos/profile_lists_repository_impl.dart';
import 'package:movies_app/features/profile/data/repos/profile_repository_impl.dart';
import 'package:movies_app/features/profile/domain/repos/profile_lists_repository.dart';
import 'package:movies_app/features/profile/domain/repos/profile_repository.dart';
import 'package:movies_app/features/profile/domain/usecases/get_history_usecase.dart';
import 'package:movies_app/features/profile/domain/usecases/get_wishlist_usecase.dart';
import 'package:movies_app/features/profile/presentation/cubit/history/history_cubit.dart';
import 'package:movies_app/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:movies_app/features/profile/presentation/cubit/wishlist/wishlist_cubit.dart';
import 'package:movies_app/features/search/presentation/cubit/search_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt
    ..registerLazySingleton<Dio>(DioFactory.create)
    ..registerLazySingleton<ApiClient>(() => ApiClient(getIt<Dio>()))
    ..registerLazySingleton<AuthService>(AuthService.new)
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt<AuthService>()),
    )
    ..registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(getIt<AuthRepository>()),
    )
    ..registerLazySingleton<RegisterUseCase>(
      () => RegisterUseCase(getIt<AuthRepository>()),
    )
    ..registerLazySingleton<ResetPasswordUseCase>(
      () => ResetPasswordUseCase(getIt<AuthRepository>()),
    )
    ..registerLazySingleton<GoogleSignInUseCase>(
      () => GoogleSignInUseCase(getIt<AuthRepository>()),
    )
    ..registerLazySingleton<SignOutUseCase>(
      () => SignOutUseCase(getIt<AuthRepository>()),
    )
    ..registerFactory<AuthCubit>(
      () => AuthCubit(
        getIt<LoginUseCase>(),
        getIt<RegisterUseCase>(),
        getIt<GoogleSignInUseCase>(),
        getIt<SignOutUseCase>(),
      ),
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
    )
    ..registerLazySingleton<ProfileListsService>(ProfileListsService.new)
    ..registerLazySingleton<ProfileListsRepository>(
      () => ProfileListsRepositoryImpl(getIt<ProfileListsService>()),
    )
    ..registerLazySingleton<GetWishlistUseCase>(
      () => GetWishlistUseCase(getIt<ProfileListsRepository>()),
    )
    ..registerLazySingleton<GetHistoryUseCase>(
      () => GetHistoryUseCase(getIt<ProfileListsRepository>()),
    )
    ..registerFactory<WishlistCubit>(
      () => WishlistCubit(getIt<GetWishlistUseCase>()),
    )
    ..registerFactory<HistoryCubit>(
      () => HistoryCubit(getIt<GetHistoryUseCase>()),
    )
    ..registerLazySingleton<MovieActivityService>(MovieActivityService.new)
    ..registerLazySingleton<MovieActivityRepository>(
      () => MovieActivityRepositoryImpl(getIt<MovieActivityService>()),
    )
    ..registerLazySingleton<CheckIsFavoriteUseCase>(
      () => CheckIsFavoriteUseCase(getIt<MovieActivityRepository>()),
    )
    ..registerLazySingleton<AddToWishlistUseCase>(
      () => AddToWishlistUseCase(getIt<MovieActivityRepository>()),
    )
    ..registerLazySingleton<RemoveFromWishlistUseCase>(
      () => RemoveFromWishlistUseCase(getIt<MovieActivityRepository>()),
    )
    ..registerLazySingleton<RecordMovieHistoryUseCase>(
      () => RecordMovieHistoryUseCase(getIt<MovieActivityRepository>()),
    )
    ..registerFactory<FavoriteCubit>(
      () => FavoriteCubit(
        getIt<CheckIsFavoriteUseCase>(),
        getIt<AddToWishlistUseCase>(),
        getIt<RemoveFromWishlistUseCase>(),
        getIt<RecordMovieHistoryUseCase>(),
      ),
    )
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
    ..registerFactory<SearchCubit>(() => SearchCubit(getIt<GetMoviesUseCase>()))
    ..registerLazySingleton<MovieDetailsRemoteDataSource>(
      () => MovieDetailsRemoteDataSource(getIt<ApiClient>()),
    )
    ..registerLazySingleton<MovieDetailsRepository>(
      () => MovieDetailsRepositoryImpl(getIt<MovieDetailsRemoteDataSource>()),
    )
    ..registerLazySingleton<GetMovieDetailsUseCase>(
      () => GetMovieDetailsUseCase(getIt<MovieDetailsRepository>()),
    )
    ..registerLazySingleton<GetMovieSuggestionsUseCase>(
      () => GetMovieSuggestionsUseCase(getIt<MovieDetailsRepository>()),
    )
    ..registerFactory<MovieDetailsCubit>(
      () => MovieDetailsCubit(
        getIt<GetMovieDetailsUseCase>(),
        getIt<GetMovieSuggestionsUseCase>(),
      ),
    );
}
