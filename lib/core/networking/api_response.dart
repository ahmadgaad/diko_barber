/// Generic API response wrapper that matches the backend envelope format.
///
/// ```json
/// {
///   "status": true,
///   "message": "...",
///   "data": { ... } | [ ... ] | null,
///   "pagination": { ... } | null
/// }
/// ```
class ApiResponse<T> {
  final bool status;
  final String? message;
  final T? data;
  final Pagination? pagination;

  const ApiResponse({
    required this.status,
    this.message,
    this.data,
    this.pagination,
  });

  /// [fromJson] receives the raw `data` value (Map, List, or primitive) and
  /// must return T. Example:
  /// ```dart
  /// ApiResponse.fromJson(json, fromJson: (d) => User.fromJson(d));
  /// ApiResponse.fromJson(json, fromJson: (d) => (d as List).map((e) => Item.fromJson(e)).toList());
  /// ```
  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic data)? fromJson,
  }) {
    final rawData = json['data'];
    T? parsedData;

    if (rawData != null) {
      parsedData = fromJson != null ? fromJson(rawData) : rawData as T?;
    }

    return ApiResponse<T>(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String?,
      data: parsedData,
      pagination: json['pagination'] is Map<String, dynamic>
          ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
          : null,
    );
  }

  bool get isSuccess => status;
  bool get isError => !status;

  @override
  String toString() =>
      'ApiResponse(status: $status, message: $message, pagination: $pagination)';
}

class Pagination {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const Pagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'] as int? ?? 1,
      lastPage: json['last_page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
    );
  }

  bool get hasNextPage => currentPage < lastPage;

  @override
  String toString() =>
      'Pagination(page: $currentPage/$lastPage, perPage: $perPage, total: $total)';
}
