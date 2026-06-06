import 'api_response.dart';

class ApiErrorModel {
  final String message;
  final int? statusCode;

  const ApiErrorModel({required this.message, this.statusCode});

  factory ApiErrorModel.fromResponse(ApiResponse response) {
    return ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف');
  }

  factory ApiErrorModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ApiErrorModel(message: 'حدث خطأ غير معروف');
    return ApiErrorModel(
      message: json['message']?.toString() ?? 'حدث خطأ غير معروف',
    );
  }

  factory ApiErrorModel.message(String message) =>
      ApiErrorModel(message: message);

  factory ApiErrorModel.withStatus(String message, int statusCode) =>
      ApiErrorModel(message: message, statusCode: statusCode);

  @override
  String toString() =>
      'ApiErrorModel(message: $message, statusCode: $statusCode)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiErrorModel &&
          message == other.message &&
          statusCode == other.statusCode;

  @override
  int get hashCode => message.hashCode ^ statusCode.hashCode;
}
