import 'dart:developer';

import 'package:ronaq_barber/core/cache/cache_keys.dart';
import 'package:ronaq_barber/core/cache/secure_storage_cache_client.dart';
import 'package:ronaq_barber/core/di/service_locator.dart';
import 'package:ronaq_barber/core/router/app_router.dart';
import 'package:ronaq_barber/core/router/app_routes.dart';
import 'package:dio/dio.dart';

class AuthorizationInterceptor extends Interceptor {
  bool _handlingUnauthorized = false;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await sl<SecureStorageCacheClient>().get(
      CacheKeys.userAccessToken,
    );

    if (token != null && token.isNotEmpty) {
      log('Adding auth token to request', name: 'AuthInterceptor');
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 401) {
      await _handleUnauthorized();
      return handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
        ),
      );
    }
    super.onResponse(response, handler);
  }

  Future<void> _handleUnauthorized() async {
    if (_handlingUnauthorized) return;
    _handlingUnauthorized = true;
    try {
      log('Received 401 Unauthorized — clearing session', name: 'AuthInterceptor');
      await sl<SecureStorageCacheClient>().clear();
      appRouter.go(AppRoutes.login);
    } finally {
      _handlingUnauthorized = false;
    }
  }
}
