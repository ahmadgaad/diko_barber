import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import 'api_error_model.dart';
import 'api_response.dart';

class ApiErrorHandler {
  ApiErrorHandler._();

  static ApiErrorModel handle(dynamic error) {
    if (error is DioException) return _handleDioException(error);
    if (error is SocketException) {
      return ApiErrorModel.message('no_internet_connection'.tr());
    }
    if (error is ApiErrorModel) return error;
    return ApiErrorModel.message('unknown_error_occurred'.tr());
  }

  static ApiErrorModel _handleDioException(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout =>
        ApiErrorModel.message('connection_timeout'.tr()),
      DioExceptionType.sendTimeout =>
        ApiErrorModel.message('send_timeout'.tr()),
      DioExceptionType.receiveTimeout =>
        ApiErrorModel.message('receive_timeout'.tr()),
      DioExceptionType.badResponse => _handleBadResponse(error.response),
      DioExceptionType.cancel =>
        ApiErrorModel.message('request_cancelled'.tr()),
      DioExceptionType.connectionError =>
        ApiErrorModel.message('connection_error'.tr()),
      DioExceptionType.badCertificate =>
        ApiErrorModel.message('bad_certificate'.tr()),
      DioExceptionType.unknown => _handleUnknown(error),
    };
  }

  static ApiErrorModel _handleUnknown(DioException error) {
    if (error.error is SocketException) {
      return ApiErrorModel.message('no_internet_connection'.tr());
    }
    if (error.response != null) return _handleBadResponse(error.response);
    return ApiErrorModel.message('general_error'.tr());
  }

  static ApiErrorModel _handleBadResponse(Response? response) {
    if (response == null) return ApiErrorModel.message('unknown_error'.tr());

    final data = response.data;
    if (data is Map<String, dynamic>) return ApiErrorModel.fromJson(data);
    return _errorForStatusCode(response.statusCode);
  }

  static ApiErrorModel _errorForStatusCode(int? statusCode) {
    final msg = switch (statusCode) {
      400 => 'bad_request'.tr(),
      401 => 'unauthorized'.tr(),
      403 => 'forbidden'.tr(),
      404 => 'not_found'.tr(),
      408 => 'request_timeout'.tr(),
      409 => 'conflict'.tr(),
      422 => 'unprocessable_entity'.tr(),
      429 => 'too_many_requests'.tr(),
      500 => 'internal_server_error'.tr(),
      502 => 'bad_gateway'.tr(),
      503 => 'service_unavailable'.tr(),
      504 => 'gateway_timeout'.tr(),
      _ => 'unknown_error'.tr(),
    };
    return ApiErrorModel.withStatus(msg, statusCode ?? 0);
  }

  static ApiErrorModel fromApiResponse(ApiResponse response) =>
      ApiErrorModel.fromResponse(response);
}
