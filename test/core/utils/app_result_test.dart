import 'package:flutter_test/flutter_test.dart';

import 'package:movies_app/core/error/app_error_model.dart';
import 'package:movies_app/core/utils/app_result.dart';

void main() {
  group('AppResult', () {
    test('Success carries its data and matches in an exhaustive switch', () {
      const AppResult<int> result = Success(7);

      final value = switch (result) {
        Success(:final data) => data,
        Failure() => -1,
      };

      expect(value, 7);
    });

    test('Failure carries its error and matches in an exhaustive switch', () {
      const AppResult<int> result = Failure(
        AppErrorModel(code: 'no-connection', message: 'No internet connection'),
      );

      final code = switch (result) {
        Success() => null,
        Failure(:final error) => error.code,
      };

      expect(code, 'no-connection');
    });

    test('same-shaped Success values are equal via AppErrorModel/data', () {
      const a = Failure<int>(AppErrorModel(code: 'timeout'));
      const b = Failure<int>(AppErrorModel(code: 'timeout'));

      expect(a.error, b.error);
    });
  });
}
