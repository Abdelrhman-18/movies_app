# Backend layer — usage guide

How to build a Phase 2 feature on top of the shared backend layer added in
`feature/network-layer`. Everything here talks through **one** result type,
`AppResult<T>`, whether the call is HTTP (Dio → Movies API) or Firebase.

- [The pieces](#the-pieces)
- [HTTP — a full feature slice (`movies`)](#http--a-full-feature-slice-movies)
- [API gotchas you must handle](#api-gotchas-you-must-handle)
- [Firebase — a full feature slice (`auth` + Firestore)](#firebase--a-full-feature-slice-auth--firestore)
- [Turning `AppErrorModel` into a shown message](#turning-apperrormodel-into-a-shown-message)
- [Testing a data source without the network](#testing-a-data-source-without-the-network)

> The example files below (`lib/features/movies/**`, `lib/features/auth/data/**`)
> do **not** exist yet — they are what a Phase 2 feature PR adds. The `lib/core/**`
> types they import are real and on this branch.

---

## The pieces

| File | What it gives you |
|---|---|
| `core/utils/app_result.dart` | `sealed AppResult<T>` → `Success<T>(data)` / `Failure<T>(error)` |
| `core/error/app_error_model.dart` | `AppErrorModel { String code; String? message; }` + `from*` factories |
| `core/network/api_client.dart` | `ApiClient.get/post<T>(...) → Future<AppResult<T>>` |
| `core/network/api_constants.dart` | base URL, endpoint paths, query-param keys, timeouts |
| `core/network/dio_factory.dart` | builds the `Dio` singleton; adds `PrettyDioLogger` in debug builds only |
| `core/network/api_response.dart` | the `{ status, status_message, data }` envelope |
| `core/services/firebase/firebase_execute.dart` | `FirebaseExecute.call<T>(action) → Future<AppResult<T>>` |
| `core/services/firebase/firestore_service.dart` | `FirestoreService.instance` — typed reads/writes/streams |
| `core/services/firebase/firestore_collections.dart` | collection-name constants |
| `core/di/service_locator.dart` | `getIt`; `configureDependencies()` (registers `Dio` + `ApiClient`) |

`Dio` and `ApiClient` are already registered. A feature adds its own data
source / repository / bloc registrations to `configureDependencies()`.

---

## HTTP — a full feature slice (`movies`)

Goal: load the popular-movies list from `GET list_movies.json`.

### 1. Payload models — `features/movies/data/models/`

Hand-written `fromJson` (no codegen), immutable + `Equatable`.

```dart
// features/movies/data/models/movie.dart
import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.coverImageUrl,
    required this.genres,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int? ?? 0,
      title: json['title_long'] as String? ?? json['title'] as String? ?? '',
      year: json['year'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      coverImageUrl: json['medium_cover_image'] as String? ?? '',
      genres:
          (json['genres'] as List<dynamic>?)?.cast<String>() ?? const <String>[],
    );
  }

  final int id;
  final String title;
  final int year;
  final double rating;
  final String coverImageUrl;
  final List<String> genres;

  /// The API returns `status: "ok"` with `id == 0` for a movie that does not
  /// exist — see the gotchas section.
  bool get isMissing => id == 0;

  @override
  List<Object?> get props => [id, title, year, rating, coverImageUrl, genres];
}
```

```dart
// features/movies/data/models/movies_page.dart
import 'package:equatable/equatable.dart';

import 'package:movies_app/features/movies/data/models/movie.dart';

class MoviesPage extends Equatable {
  const MoviesPage({
    required this.movieCount,
    required this.pageNumber,
    required this.movies,
  });

  factory MoviesPage.fromJson(Map<String, dynamic> json) {
    return MoviesPage(
      movieCount: json['movie_count'] as int? ?? 0,
      pageNumber: json['page_number'] as int? ?? 1,
      movies:
          (json['movies'] as List<dynamic>?)
              ?.map((e) => Movie.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Movie>[],
    );
  }

  final int movieCount;
  final int pageNumber;
  final List<Movie> movies;

  @override
  List<Object?> get props => [movieCount, pageNumber, movies];
}
```

### 2. Remote data source — `features/movies/data/data_sources/`

The **only** place a raw endpoint string / query key appears. It calls
`ApiClient.get` and hands back the `AppResult` unchanged.

```dart
// features/movies/data/data_sources/movies_remote_data_source.dart
import 'package:movies_app/core/network/api_client.dart';
import 'package:movies_app/core/network/api_constants.dart';
import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/movies/data/models/movie.dart';
import 'package:movies_app/features/movies/data/models/movies_page.dart';

class MoviesRemoteDataSource {
  const MoviesRemoteDataSource(this._client);

  final ApiClient _client;

  Future<AppResult<MoviesPage>> listMovies({
    int page = 1,
    int limit = 20,
    String? query,
    String? genre,
  }) {
    return _client.get<MoviesPage>(
      ApiConstants.listMovies,
      queryParameters: {
        ApiConstants.page: page,
        ApiConstants.limit: limit,
        if (query != null && query.isNotEmpty) ApiConstants.queryTerm: query,
        if (genre != null) ApiConstants.genre: genre,
      },
      dataFromJson: MoviesPage.fromJson,
    );
  }

  Future<AppResult<Movie>> movieDetails(int movieId) {
    return _client.get<Movie>(
      ApiConstants.movieDetails,
      queryParameters: {
        ApiConstants.movieId: movieId,
        ApiConstants.withImages: true,
        ApiConstants.withCast: true,
      },
      // data is `{ "movie": { ... } }`
      dataFromJson: (data) => Movie.fromJson(data['movie'] as Map<String, dynamic>),
    );
  }
}
```

`ApiClient` already did all of this for you before you see the result:

- ran the Dio call with the base URL + timeouts + `PrettyDioLogger` (debug only)
- caught every `DioException` → `Failure(AppErrorModel.fromDioException(...))`
- unwrapped `{ status, status_message, data }`
- a `status: "error"` body (even on HTTP 200) → `Failure(...)` with the server message
- a non-JSON / non-object body → `Failure(code: 'malformed-response')`

### 3. Repository — `features/movies/data/repositories/`

For a pure pass-through the repository is thin, but it is the seam where you add
caching, mapping to domain entities, or the "missing movie" rule:

```dart
// features/movies/data/repositories/movies_repository.dart
import 'package:movies_app/core/error/app_error_model.dart';
import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/movies/data/data_sources/movies_remote_data_source.dart';
import 'package:movies_app/features/movies/data/models/movie.dart';
import 'package:movies_app/features/movies/data/models/movies_page.dart';

class MoviesRepository {
  const MoviesRepository(this._remote);

  final MoviesRemoteDataSource _remote;

  Future<AppResult<MoviesPage>> popular({int page = 1}) =>
      _remote.listMovies(page: page);

  Future<AppResult<Movie>> details(int movieId) async {
    final result = await _remote.movieDetails(movieId);
    return switch (result) {
      Success(:final data) when data.isMissing => const Failure(
        AppErrorModel(code: 'movie-not-found'),
      ),
      _ => result,
    };
  }
}
```

### 4. Bloc + states — `features/movies/logic/`

States are a Dart 3 `sealed` hierarchy with the `Loading` / `Success` / `Empty` /
`Error` set CLAUDE.md requires for list features. Prefix them (`MoviesList…`) so
`MoviesListSuccess` never clashes with `AppResult`'s `Success`.

```dart
// features/movies/logic/movies_list_state.dart
import 'package:equatable/equatable.dart';

import 'package:movies_app/core/error/app_error_model.dart';

import 'package:movies_app/features/movies/data/models/movie.dart';

sealed class MoviesListState extends Equatable {
  const MoviesListState();

  @override
  List<Object?> get props => [];
}

final class MoviesListLoading extends MoviesListState {
  const MoviesListLoading();
}

final class MoviesListSuccess extends MoviesListState {
  const MoviesListSuccess(this.movies);

  final List<Movie> movies;

  @override
  List<Object?> get props => [movies];
}

final class MoviesListEmpty extends MoviesListState {
  const MoviesListEmpty();
}

final class MoviesListError extends MoviesListState {
  const MoviesListError(this.error);

  final AppErrorModel error;

  @override
  List<Object?> get props => [error];
}
```

```dart
// features/movies/logic/movies_list_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/movies/data/repositories/movies_repository.dart';
import 'package:movies_app/features/movies/logic/movies_list_state.dart';

class MoviesListCubit extends Cubit<MoviesListState> {
  MoviesListCubit(this._repository) : super(const MoviesListLoading());

  final MoviesRepository _repository;

  Future<void> load() async {
    emit(const MoviesListLoading());
    final result = await _repository.popular();
    emit(switch (result) {
      Success(:final data) when data.movies.isEmpty => const MoviesListEmpty(),
      Success(:final data) => MoviesListSuccess(data.movies),
      Failure(:final error) => MoviesListError(error),
    });
  }
}
```

### 5. Presentation — exhaustive `switch` on the state

```dart
BlocBuilder<MoviesListCubit, MoviesListState>(
  builder: (context, state) => switch (state) {
    MoviesListLoading() => const _MoviesShimmer(),
    MoviesListSuccess(:final movies) => _MoviesGrid(movies: movies),
    MoviesListEmpty() => AppEmptyView(message: context.l10n.noResults),
    MoviesListError(:final error) => AppErrorView(
      message: context.messageFor(error), // see localization section
      onRetry: () => context.read<MoviesListCubit>().load(),
    ),
  },
)
```

### 6. Register the feature in DI

Add to `configureDependencies()` in `core/di/service_locator.dart`:

```dart
getIt
  ..registerLazySingleton<MoviesRemoteDataSource>(
    () => MoviesRemoteDataSource(getIt<ApiClient>()),
  )
  ..registerLazySingleton<MoviesRepository>(
    () => MoviesRepository(getIt<MoviesRemoteDataSource>()),
  )
  ..registerFactory<MoviesListCubit>(
    () => MoviesListCubit(getIt<MoviesRepository>()),
  );
```

Then `BlocProvider(create: (_) => getIt<MoviesListCubit>()..load())`.

---

## API gotchas you must handle

| Situation | What the API returns | Where to handle it |
|---|---|---|
| `list_movies.json?query_term=<no matches>` | `status: "ok"`, `movie_count: 0`, `movies` empty/absent | Bloc → `MoviesListEmpty` (it is **not** a `Failure`) |
| `movie_details.json?movie_id=999999999` | `status: "ok"` but `movie.id == 0`, `title` null | Repository → check `Movie.isMissing`, return `Failure(code: 'movie-not-found')` |
| `movie_suggestions.json` with no / non-numeric `movie_id` | `status: "error"`, `status_message: "movie_id is null"`, **no `data`** | `ApiClient` already turns this into `Failure` with the server message |
| wrong endpoint | HTTP 404, not a JSON envelope | `ApiClient` → `Failure(code: 'http-404')` |

The first two look like success to `ApiClient` (they *are* `status: "ok"`), so
they are the feature's job. The last two `ApiClient` handles for you.

---

## Firebase — a full feature slice (`auth` + Firestore)

### Auth call — wrap it in `FirebaseExecute`

`FirebaseExecute.call` runs the action and folds `FirebaseAuthException` /
`FirebaseException` / anything else into `Failure(AppErrorModel...)`.

```dart
// features/auth/data/data_sources/auth_remote_data_source.dart
import 'package:firebase_auth/firebase_auth.dart';

import 'package:movies_app/core/services/firebase/firebase_execute.dart';
import 'package:movies_app/core/utils/app_result.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._auth);

  final FirebaseAuth _auth;

  Future<AppResult<User>> signIn({
    required String email,
    required String password,
  }) {
    return FirebaseExecute.call<User>(() async {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    });
  }

  Future<AppResult<void>> signOut() =>
      FirebaseExecute.call<void>(_auth.signOut);
}
```

The bloc consumes it exactly like the HTTP example:

```dart
final result = await _dataSource.signIn(email: email, password: password);
emit(switch (result) {
  Success() => const LoginSuccess(),
  Failure(:final error) => LoginError(error), // error.code is e.g. 'wrong-password'
});
```

### Firestore write — through `FirestoreService`

Paths are built from `FirestoreCollections`, never string literals.

```dart
// features/profile/data/data_sources/profile_remote_data_source.dart
import 'package:movies_app/core/services/firebase/firebase_execute.dart';
import 'package:movies_app/core/services/firebase/firestore_collections.dart';
import 'package:movies_app/core/services/firebase/firestore_service.dart';
import 'package:movies_app/core/utils/app_result.dart';

class ProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._firestore);

  final FirestoreService _firestore;

  Future<AppResult<void>> saveProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) {
    return FirebaseExecute.call<void>(
      () => _firestore.setData(
        path: '${FirestoreCollections.users}/$uid',
        data: data,
        merge: true,
      ),
    );
  }

  Future<AppResult<String>> addToWishlist({
    required String uid,
    required Map<String, dynamic> movie,
  }) {
    return FirebaseExecute.call<String>(
      () => _firestore.addData(
        path: '${FirestoreCollections.users}/$uid/${FirestoreCollections.wishlist}',
        data: movie,
      ),
    );
  }
}
```

### Firestore stream — map errors with `AppErrorModel.fromStreamError`

`collectionStream` / `documentStream` rethrow their errors, so the bloc's
`onError` converts them:

```dart
// inside a bloc
_sub = FirestoreService.instance
    .collectionStream<WishlistItem>(
      path: '${FirestoreCollections.users}/$uid/${FirestoreCollections.wishlist}',
      builder: (data, id) => WishlistItem.fromMap(data, id),
    )
    .listen(
      (items) => emit(items.isEmpty ? const WishlistEmpty() : WishlistLoaded(items)),
      onError: (Object error) =>
          emit(WishlistError(AppErrorModel.fromStreamError(error))),
    );
```

### Register Firebase feature deps

`FirestoreService.instance` and `FirebaseExecute` are singletons/static, so a
feature only registers `FirebaseAuth.instance` if it wants it injected:

```dart
getIt
  ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
  ..registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<FirebaseAuth>()),
  );
```

---

## Turning `AppErrorModel` into a shown message

`AppErrorModel` carries a machine-readable `code` and an optional raw `message`.
The presentation layer maps `code` → a localized string, falling back to
`message`, then to a generic string. Put this in a `core/` extension (Team Lead
merges it) once the ARB keys exist:

```dart
// core/utils/error_messages.dart  (illustrative — needs new ARB keys)
extension ErrorMessages on BuildContext {
  String messageFor(AppErrorModel error) => switch (error.code) {
    'no-connection' => l10n.errorNoConnection,
    'timeout' => l10n.errorTimeout,
    'movie-not-found' => l10n.errorMovieNotFound,
    'wrong-password' || 'invalid-credential' => l10n.errorWrongCredentials,
    'email-already-in-use' => l10n.errorEmailInUse,
    _ => error.message ?? l10n.somethingWentWrong, // key already exists
  };
}
```

Never show `error.code` directly and never build a user string in a data source.

---

## Testing a data source without the network

`ApiClient` takes a `Dio`, so swap Dio's adapter for a stub (see
`test/core/network/api_client_test.dart` for the full helper):

```dart
class _StubAdapter implements HttpClientAdapter {
  _StubAdapter(this.respond);
  final ResponseBody Function(RequestOptions) respond;
  @override
  void close({bool force = false}) {}
  @override
  Future<ResponseBody> fetch(RequestOptions o, Stream<Uint8List>? _, Future<void>? __) async =>
      respond(o);
}

ApiClient stubbedClient(Object body, {int statusCode = 200}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://test/'))
    ..httpClientAdapter = _StubAdapter(
      (_) => ResponseBody.fromString(
        jsonEncode(body),
        statusCode,
        headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
      ),
    );
  return ApiClient(dio);
}

test('listMovies maps the envelope to a MoviesPage', () async {
  final client = stubbedClient({
    'status': 'ok',
    'status_message': 'Query was successful',
    'data': {'movie_count': 1, 'page_number': 1, 'movies': [
      {'id': 10, 'title': 'X', 'year': 2020, 'rating': 7.5, 'genres': ['Drama']},
    ]},
  });

  final result = await MoviesRemoteDataSource(client).listMovies();

  expect(result, isA<Success<MoviesPage>>());
  expect((result as Success<MoviesPage>).data.movies.single.id, 10);
});
```

For Firebase, inject `FirebaseAuth` / a `FirestoreService` seam and use
`firebase_auth_mocks` / `fake_cloud_firestore` (add as `dev_dependencies` when
the first auth feature lands).
