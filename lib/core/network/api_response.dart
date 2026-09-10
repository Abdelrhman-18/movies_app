import 'package:equatable/equatable.dart';

import 'package:movies_app/core/error/app_error_model.dart';

class ApiResponse<T> extends Equatable {
  const ApiResponse({this.status, this.statusMessage, this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> data) dataFromJson,
  ) {
    final rawData = json['data'];
    return ApiResponse<T>(
      status: json['status'] as String?,
      statusMessage: json['status_message'] as String?,
      data: rawData is Map<String, dynamic> ? dataFromJson(rawData) : null,
    );
  }

  final String? status;
  final String? statusMessage;
  final T? data;

  bool get isError => status == 'error';

  bool get isSuccess => status == 'ok' && data != null;

  AppErrorModel toError() => AppErrorModel.fromApiEnvelope(
    status: status,
    statusMessage: statusMessage,
  );

  @override
  List<Object?> get props => [status, statusMessage, data];
}
