import 'package:dio/dio.dart';

import 'api_response.dart';

/// Abstract interface for network service operations.
///
/// This interface defines the contract for making HTTP requests.
/// Implementations should return [ApiResponse] which wraps the
/// backend's standard envelope format.
abstract class INetworkService {
  /// Performs a GET request to the specified endpoint.
  ///
  /// [endPoint] - The API endpoint path (relative to base URL)
  /// [queryParameters] - Optional query parameters to append to the URL
  /// [options] - Optional Dio request options for customization
  ///
  /// Returns [ApiResponse] containing the parsed response data.
  Future<ApiResponse<dynamic>> getData({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  /// Performs a POST request to the specified endpoint.
  ///
  /// [endPoint] - The API endpoint path (relative to base URL)
  /// [queryParameters] - Optional query parameters to append to the URL
  /// [body] - The request body data
  /// [enableFormData] - If true, converts body to FormData for multipart requests
  /// [options] - Optional Dio request options for customization
  ///
  /// Returns [ApiResponse] containing the parsed response data.
  Future<ApiResponse<dynamic>> postData({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    bool enableFormData = false,
    Options? options,
    ProgressCallback? onSendProgress,
  });

  /// Performs a PUT request to the specified endpoint.
  ///
  /// [endPoint] - The API endpoint path (relative to base URL)
  /// [queryParameters] - Optional query parameters to append to the URL
  /// [body] - The request body data
  /// [enableFormData] - If true, converts body to FormData for multipart requests
  /// [options] - Optional Dio request options for customization
  ///
  /// Returns [ApiResponse] containing the parsed response data.
  Future<ApiResponse<dynamic>> putData({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    bool enableFormData = false,
    Options? options,
  });

  /// Performs a PATCH request to the specified endpoint.
  ///
  /// [endPoint] - The API endpoint path (relative to base URL)
  /// [queryParameters] - Optional query parameters to append to the URL
  /// [body] - The request body data
  /// [enableFormData] - If true, converts body to FormData for multipart requests
  /// [options] - Optional Dio request options for customization
  ///
  /// Returns [ApiResponse] containing the parsed response data.
  Future<ApiResponse<dynamic>> patchData({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    bool enableFormData = false,
    Options? options,
  });

  /// Performs a DELETE request to the specified endpoint.
  ///
  /// [endPoint] - The API endpoint path (relative to base URL)
  /// [queryParameters] - Optional query parameters to append to the URL
  /// [options] - Optional Dio request options for customization
  ///
  /// Returns [ApiResponse] containing the parsed response data.
  Future<ApiResponse<dynamic>> deleteData({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    Options? options,
  });
}
