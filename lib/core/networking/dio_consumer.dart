import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ronaq_barber/core/cache/cache_keys.dart';
import 'package:ronaq_barber/core/networking/api_error_handler.dart';
import 'package:ronaq_barber/core/networking/api_response.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_consumer.dart';
import 'interceptors/authorization_interceptor.dart';

const _baseUrl =
    'https://lavenderblush-gerbil-236148.hostingersite.com/api/v1/';

class DioConsumer implements INetworkService {
  final Dio dioClient;

  DioConsumer({
    required this.dioClient,
    required AuthorizationInterceptor authInterceptor,
    SharedPreferences? prefs,
  }) {
    _configureDio(authInterceptor, prefs);
  }

  void _configureDio(
    AuthorizationInterceptor authInterceptor,
    SharedPreferences? prefs,
  ) {
    final language = prefs?.getString(CacheKeys.locale) ?? 'ar';

    dioClient.options = BaseOptions(
      baseUrl: _baseUrl,
      contentType: 'application/json',
      headers: {
        'Accept': 'application/json',
        'Accept-Language': language,
      },
      followRedirects: false,
      validateStatus: (status) => status != null && status < 500,
      receiveDataWhenStatusError: true,
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      connectTimeout: const Duration(seconds: 30),
    );

    dioClient.interceptors.addAll([
      authInterceptor,
      if (kDebugMode) PrettyDioLogger(requestBody: true, requestHeader: true),
    ]);
  }

  void refreshAcceptLanguage(String languageCode) {
    dioClient.options.headers['Accept-Language'] = languageCode;
  }

  @override
  Future<ApiResponse<dynamic>> getData({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _executeRequest(
      () => dioClient.get(
        endPoint,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  @override
  Future<ApiResponse<dynamic>> postData({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    bool enableFormData = false,
    Options? options,
    ProgressCallback? onSendProgress,
  }) async {
    return _executeRequest(
      () => dioClient.post(
        endPoint,
        data: enableFormData ? _toFormData(body) : body,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
      ),
    );
  }

  @override
  Future<ApiResponse<dynamic>> putData({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    bool enableFormData = false,
    Options? options,
  }) async {
    return _executeRequest(
      () => dioClient.put(
        endPoint,
        data: enableFormData ? _toFormData(body) : body,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  @override
  Future<ApiResponse<dynamic>> patchData({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    bool enableFormData = false,
    Options? options,
  }) async {
    return _executeRequest(
      () => dioClient.patch(
        endPoint,
        data: enableFormData ? _toFormData(body) : body,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  @override
  Future<ApiResponse<dynamic>> deleteData({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    Options? options,
  }) async {
    return _executeRequest(
      () => dioClient.delete(
        endPoint,
        data: body,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<ApiResponse<dynamic>> _executeRequest(
    Future<Response<dynamic>> Function() request,
  ) async {
    try {
      final response = await request();
      return _parseResponse(response);
    } on SocketException {
      return ApiResponse(
        status: false,
        message: 'no_internet_connection'.tr(),
      );
    } on DioException catch (e) {
      final errorModel = ApiErrorHandler.handle(e);
      return ApiResponse(status: false, message: errorModel.message);
    } on Exception catch (_) {
      return ApiResponse(
        status: false,
        message: 'unknown_error_occurred'.tr(),
      );
    }
  }

  ApiResponse<dynamic> _parseResponse(Response response) {
    final data = response.data;

    if (data == null) {
      return ApiResponse(
        status: response.statusCode != null && response.statusCode! < 400,
        message: response.statusMessage,
      );
    }

    if (data is Map<String, dynamic>) {
      return ApiResponse<dynamic>.fromJson(data);
    }

    return ApiResponse(
      status: response.statusCode != null && response.statusCode! < 400,
      message: 'unexpected_response_format'.tr(),
    );
  }

  FormData _toFormData(dynamic body) {
    if (body is Map<String, dynamic>) return FormData.fromMap(body);
    if (body is List) return FormData.fromMap({'data': body});
    return FormData.fromMap(body as Map<String, dynamic>);
  }
}
