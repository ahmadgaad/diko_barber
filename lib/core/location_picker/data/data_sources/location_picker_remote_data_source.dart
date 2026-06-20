import 'package:dio/dio.dart';

abstract class LocationPickerRemoteDataSource {
  Future<Map<String, dynamic>> reverseGeocode(
    double lat,
    double lng,
    String language,
  );

  Future<Map<String, dynamic>> geocodeByPlaceId(
    String placeId,
    String language,
  );

  Future<Map<String, dynamic>> fetchAutocompleteSuggestions(
    String query,
    String language,
  );
}

class LocationPickerRemoteDataSourceImpl
    implements LocationPickerRemoteDataSource {
  LocationPickerRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  static const _apiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
  static const _geocodeBase =
      'https://maps.googleapis.com/maps/api/geocode/json';
  static const _autocompleteBase =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';

  @override
  Future<Map<String, dynamic>> reverseGeocode(
    double lat,
    double lng,
    String language,
  ) async {
    final response = await _dio.get<Map<String, dynamic>>(
      _geocodeBase,
      queryParameters: {
        'latlng': '$lat,$lng',
        'language': language,
        'key': _apiKey,
      },
    );
    return response.data!;
  }

  @override
  Future<Map<String, dynamic>> geocodeByPlaceId(
    String placeId,
    String language,
  ) async {
    final response = await _dio.get<Map<String, dynamic>>(
      _geocodeBase,
      queryParameters: {
        'place_id': placeId,
        'language': language,
        'key': _apiKey,
      },
    );
    return response.data!;
  }

  @override
  Future<Map<String, dynamic>> fetchAutocompleteSuggestions(
    String query,
    String language,
  ) async {
    final response = await _dio.get<Map<String, dynamic>>(
      _autocompleteBase,
      queryParameters: {
        'input': query,
        'language': language,
        'key': _apiKey,
      },
    );
    return response.data!;
  }
}
