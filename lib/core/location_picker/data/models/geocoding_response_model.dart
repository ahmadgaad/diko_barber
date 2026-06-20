import 'package:zain/core/location_picker/domain/entities/geocoding_result.dart';

class GeocodingResponseModel {
  const GeocodingResponseModel({required this.status, required this.results});

  final String status;
  final List<GeocodingResultModel> results;

  factory GeocodingResponseModel.fromJson(Map<String, dynamic> json) {
    return GeocodingResponseModel(
      status: json['status'] as String? ?? '',
      results: (json['results'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map(GeocodingResultModel.fromJson)
              .toList() ??
          [],
    );
  }

  bool get isOk => status == 'OK';

  GeocodingResult? get firstResult {
    if (results.isEmpty) return null;
    final r = results.first;
    return GeocodingResult(
      formattedAddress: r.formattedAddress,
      lat: r.lat,
      lng: r.lng,
      placeId: r.placeId,
    );
  }
}

class GeocodingResultModel {
  const GeocodingResultModel({
    required this.formattedAddress,
    required this.lat,
    required this.lng,
    this.placeId,
  });

  final String formattedAddress;
  final double lat;
  final double lng;
  final String? placeId;

  factory GeocodingResultModel.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry'] as Map<String, dynamic>?;
    final location = geometry?['location'] as Map<String, dynamic>?;

    return GeocodingResultModel(
      formattedAddress: json['formatted_address'] as String? ?? '',
      lat: (location?['lat'] as num?)?.toDouble() ?? 0,
      lng: (location?['lng'] as num?)?.toDouble() ?? 0,
      placeId: json['place_id'] as String?,
    );
  }
}
