import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:movies_app/core/network/api_client.dart';
import 'package:movies_app/core/utils/app_result.dart';

class _StubAdapter implements HttpClientAdapter {
  _StubAdapter(this.respond);

  final ResponseBody Function(RequestOptions options) respond;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => respond(options);
}

ResponseBody _jsonBody(Object? body, {int statusCode = 200}) {
  return ResponseBody.fromString(
    jsonEncode(body),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

ApiClient _clientReturning(ResponseBody Function(RequestOptions) respond) {
  final dio = Dio(BaseOptions(baseUrl: 'https://movies-api.test/api/v2/'))
    ..httpClientAdapter = _StubAdapter(respond);
  return ApiClient(dio);
}

void main() {
  test('unwraps a success envelope into Success(payload)', () async {
    final client = _clientReturning(
      (_) => _jsonBody({
        'status': 'ok',
        'status_message': 'Query was successful',
        'data': {'movie_count': 3},
      }),
    );

    final result = await client.get<int>(
      'list_movies.json',
      dataFromJson: (data) => data['movie_count'] as int,
    );

    expect(result, isA<Success<int>>());
    expect((result as Success<int>).data, 3);
  });

  test('a status:"error" envelope on HTTP 200 becomes a Failure', () async {
    final client = _clientReturning(
      (_) =>
          _jsonBody({'status': 'error', 'status_message': 'movie_id is null'}),
    );

    final result = await client.get<int>(
      'movie_suggestions.json',
      dataFromJson: (_) => 0,
    );

    expect(result, isA<Failure<int>>());
    expect((result as Failure<int>).error.message, 'movie_id is null');
  });

  test('an HTTP 404 becomes a Failure with a coded error', () async {
    final client = _clientReturning(
      (_) => _jsonBody({'message': 'not found'}, statusCode: 404),
    );

    final result = await client.get<int>(
      'wrong_endpoint.json',
      dataFromJson: (_) => 0,
    );

    expect(result, isA<Failure<int>>());
    expect((result as Failure<int>).error.code, 'http-404');
  });

  test('a non-map body becomes a Failure', () async {
    final client = _clientReturning((_) => _jsonBody('just a string'));

    final result = await client.get<int>(
      'list_movies.json',
      dataFromJson: (_) => 0,
    );

    expect(result, isA<Failure<int>>());
  });
}
