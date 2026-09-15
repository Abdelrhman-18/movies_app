import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final class AppErrorModel extends Equatable {
  const AppErrorModel({required this.code, this.message});

  factory AppErrorModel.fromFirebaseAuthException(FirebaseAuthException e) {
    return AppErrorModel(code: e.code, message: e.message);
  }

  factory AppErrorModel.fromFirebaseException(FirebaseException e) {
    return AppErrorModel(code: e.code, message: e.message);
  }

  factory AppErrorModel.fromGoogleSignInException(GoogleSignInException e) {
    return AppErrorModel(
      code: e.code == GoogleSignInExceptionCode.canceled
          ? 'cancelled'
          : 'google-sign-in-failed',
      message: e.description,
    );
  }

  factory AppErrorModel.unexpected([String? message]) {
    return AppErrorModel(code: 'unexpected', message: message);
  }

  factory AppErrorModel.fromStreamError(Object error) {
    return error is FirebaseException
        ? AppErrorModel.fromFirebaseException(error)
        : AppErrorModel.unexpected(error.toString());
  }

  factory AppErrorModel.fromDioException(DioException exception) {
    return switch (exception.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout => const AppErrorModel(
        code: 'timeout',
        message: 'Connection timeout, please try again',
      ),
      DioExceptionType.connectionError => const AppErrorModel(
        code: 'no-connection',
        message: 'No internet connection',
      ),
      DioExceptionType.badCertificate => const AppErrorModel(
        code: 'bad-certificate',
        message: 'Could not establish a secure connection',
      ),
      DioExceptionType.cancel => const AppErrorModel(
        code: 'cancelled',
        message: 'Request cancelled',
      ),
      DioExceptionType.badResponse => _fromBadResponse(exception.response),
      DioExceptionType.unknown => AppErrorModel.unexpected(exception.message),
    };
  }

  factory AppErrorModel.fromApiEnvelope({
    String? status,
    String? statusMessage,
    int? statusCode,
  }) {
    return AppErrorModel(
      code: statusCode != null ? 'http-$statusCode' : (status ?? 'api-error'),
      message: statusMessage,
    );
  }

  final String code;
  final String? message;

  static AppErrorModel _fromBadResponse(Response<dynamic>? response) {
    final body = response?.data;
    final statusCode = response?.statusCode;
    if (body is Map<String, dynamic> && body['status'] == 'error') {
      return AppErrorModel.fromApiEnvelope(
        status: body['status'] as String?,
        statusMessage: body['status_message'] as String?,
        statusCode: statusCode,
      );
    }
    return AppErrorModel(
      code: 'http-$statusCode',
      message: 'Server error ($statusCode)',
    );
  }

  @override
  List<Object?> get props => [code, message];
}
