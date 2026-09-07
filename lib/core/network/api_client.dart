import 'package:dio/dio.dart';

import 'package:movies_app/core/error/app_error_model.dart';
import 'package:movies_app/core/network/api_response.dart';
import 'package:movies_app/core/utils/app_result.dart';

class ApiClient {
  const ApiClient(this._dio);

  final Dio _dio;

  Future<AppResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic> data) dataFromJson,
  }) {
    return _send<T>(
      () => _dio.get<dynamic>(path, queryParameters: queryParameters),
      dataFromJson,
    );
  }

  Future<AppResult<T>> post<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic> data) dataFromJson,
  }) {
    return _send<T>(
      () => _dio.post<dynamic>(
        path,
        data: body,
        queryParameters: queryParameters,
      ),
      dataFromJson,
    );
  }

  Future<AppResult<T>> _send<T>(
    Future<Response<dynamic>> Function() request,
    T Function(Map<String, dynamic> data) dataFromJson,
  ) async {
    try {
      final response = await request();
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        return Failure<T>(
          const AppErrorModel(
            code: 'malformed-response',
            message: 'Received a malformed response',
          ),
        );
      }

      final envelope = ApiResponse<T>.fromJson(body, dataFromJson);
      if (envelope.isError) {
        return Failure<T>(envelope.toError());
      }

      final data = envelope.data;
      if (data == null) {
        return Failure<T>(
          const AppErrorModel(
            code: 'empty-response',
            message: 'Received an empty response',
          ),
        );
      }
      return Success<T>(data);
    } on DioException catch (exception) {
      return Failure<T>(AppErrorModel.fromDioException(exception));
    } catch (error) {
      return Failure<T>(AppErrorModel.unexpected(error.toString()));
    }
  }
}
