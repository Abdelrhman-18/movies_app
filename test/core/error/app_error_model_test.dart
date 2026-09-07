import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:movies_app/core/error/app_error_model.dart';

void main() {
  RequestOptions options() => RequestOptions(path: 'list_movies.json');

  DioException dioError(
    DioExceptionType type, {
    Response<dynamic>? response,
    String? message,
  }) => DioException(
    requestOptions: options(),
    type: type,
    response: response,
    message: message,
  );

  group('AppErrorModel.fromDioException', () {
    for (final type in const [
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.transformTimeout,
    ]) {
      test('$type -> timeout', () {
        expect(AppErrorModel.fromDioException(dioError(type)).code, 'timeout');
      });
    }

    test('connectionError -> no-connection', () {
      expect(
        AppErrorModel.fromDioException(
          dioError(DioExceptionType.connectionError),
        ).code,
        'no-connection',
      );
    });

    test('cancel -> cancelled', () {
      expect(
        AppErrorModel.fromDioException(dioError(DioExceptionType.cancel)).code,
        'cancelled',
      );
    });

    test('unknown -> unexpected, keeping the Dio message', () {
      final error = AppErrorModel.fromDioException(
        dioError(DioExceptionType.unknown, message: 'socket closed'),
      );

      expect(error.code, 'unexpected');
      expect(error.message, 'socket closed');
    });

    test('badResponse with the API error envelope keeps its message', () {
      final error = AppErrorModel.fromDioException(
        dioError(
          DioExceptionType.badResponse,
          response: Response<dynamic>(
            requestOptions: options(),
            statusCode: 422,
            data: const {
              'status': 'error',
              'status_message': 'movie_id is null',
            },
          ),
        ),
      );

      expect(error.code, 'http-422');
      expect(error.message, 'movie_id is null');
    });

    test('badResponse without an envelope -> coded server error', () {
      final error = AppErrorModel.fromDioException(
        dioError(
          DioExceptionType.badResponse,
          response: Response<dynamic>(
            requestOptions: options(),
            statusCode: 404,
            data: '<html>Not Found</html>',
          ),
        ),
      );

      expect(error.code, 'http-404');
      expect(error.message, contains('404'));
    });
  });

  group('AppErrorModel.fromApiEnvelope', () {
    test('HTTP 200 error envelope maps status_message to message', () {
      final error = AppErrorModel.fromApiEnvelope(
        status: 'error',
        statusMessage: 'movie_id is null',
      );

      expect(error.code, 'error');
      expect(error.message, 'movie_id is null');
    });
  });

  group('AppErrorModel', () {
    test('is value-equal on code + message', () {
      expect(
        const AppErrorModel(code: 'timeout', message: 'x'),
        const AppErrorModel(code: 'timeout', message: 'x'),
      );
    });

    test('unexpected() defaults its code', () {
      expect(AppErrorModel.unexpected().code, 'unexpected');
    });
  });
}
