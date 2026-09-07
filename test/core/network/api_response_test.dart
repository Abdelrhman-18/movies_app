import 'package:flutter_test/flutter_test.dart';

import 'package:movies_app/core/network/api_response.dart';

void main() {
  group('ApiResponse.fromJson', () {
    test('parses a success envelope and delegates data parsing', () {
      final json = <String, dynamic>{
        'status': 'ok',
        'status_message': 'Query was successful',
        'data': {'movie_count': 2},
        '@meta': {'api_version': 2},
      };

      final response = ApiResponse<int>.fromJson(
        json,
        (data) => data['movie_count'] as int,
      );

      expect(response.status, 'ok');
      expect(response.statusMessage, 'Query was successful');
      expect(response.data, 2);
      expect(response.isSuccess, isTrue);
      expect(response.isError, isFalse);
    });

    test('an error envelope has no data and converts to an AppErrorModel', () {
      final json = <String, dynamic>{
        'status': 'error',
        'status_message': 'movie_id is null',
        '@meta': {'api_version': 2},
      };

      final response = ApiResponse<int>.fromJson(json, (_) => 0);

      expect(response.data, isNull);
      expect(response.isSuccess, isFalse);
      expect(response.isError, isTrue);

      final error = response.toError();
      expect(error.code, 'error');
      expect(error.message, 'movie_id is null');
    });

    test('a zero-result list is still a success (empty, not error)', () {
      final json = <String, dynamic>{
        'status': 'ok',
        'status_message': 'Query was successful',
        'data': {'movie_count': 0, 'movies': <dynamic>[]},
      };

      final response = ApiResponse<int>.fromJson(
        json,
        (data) => (data['movies'] as List<dynamic>).length,
      );

      expect(response.isSuccess, isTrue);
      expect(response.data, 0);
    });
  });
}
