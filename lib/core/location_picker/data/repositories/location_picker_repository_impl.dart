import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/core/location_picker/data/data_sources/location_picker_remote_data_source.dart';
import 'package:zain/core/location_picker/data/models/geocoding_response_model.dart';
import 'package:zain/core/location_picker/domain/entities/geocoding_result.dart';
import 'package:zain/core/location_picker/domain/entities/place_prediction.dart';
import 'package:zain/core/location_picker/domain/repositories/location_picker_repository.dart';

class LocationPickerRepositoryImpl implements LocationPickerRepository {
  const LocationPickerRepositoryImpl(this._dataSource, this._prefs);

  final LocationPickerRemoteDataSource _dataSource;
  final SharedPreferences _prefs;

  String get _language {
    final saved = _prefs.getString('locale');
    return saved ?? 'ar';
  }

  @override
  Future<Result<ApiErrorModel, GeocodingResult>> reverseGeocode(
    double lat,
    double lng,
  ) async {
    try {
      final json = await _dataSource.reverseGeocode(lat, lng, _language);
      final response = GeocodingResponseModel.fromJson(json);

      if (!response.isOk || response.firstResult == null) {
        return Failure(ApiErrorModel(message: 'لم يتم العثور على عنوان'));
      }

      return Success(response.firstResult!);
    } catch (e, st) {
      log('reverseGeocode failed', error: e, stackTrace: st, name: 'LocationPicker');
      return Failure(ApiErrorModel(message: 'حدث خطأ أثناء تحديد العنوان'));
    }
  }

  @override
  Future<Result<ApiErrorModel, GeocodingResult>> geocodeByPlaceId(
    String placeId,
  ) async {
    try {
      final json = await _dataSource.geocodeByPlaceId(placeId, _language);
      final response = GeocodingResponseModel.fromJson(json);

      if (!response.isOk || response.firstResult == null) {
        return Failure(ApiErrorModel(message: 'لم يتم العثور على الموقع'));
      }

      return Success(response.firstResult!);
    } catch (e, st) {
      log('geocodeByPlaceId failed', error: e, stackTrace: st, name: 'LocationPicker');
      return Failure(ApiErrorModel(message: 'حدث خطأ أثناء تحديد الموقع'));
    }
  }

  @override
  Future<Result<ApiErrorModel, List<PlacePrediction>>>
      fetchAutocompleteSuggestions(String query) async {
    try {
      final json = await _dataSource.fetchAutocompleteSuggestions(
        query,
        _language,
      );

      final status = json['status'] as String? ?? '';
      if (status != 'OK' && status != 'ZERO_RESULTS') {
        return Failure(ApiErrorModel(message: 'فشل البحث عن الموقع'));
      }

      final predictions = (json['predictions'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map((p) {
            final structured =
                p['structured_formatting'] as Map<String, dynamic>? ?? {};
            return PlacePrediction(
              placeId: p['place_id'] as String? ?? '',
              description: p['description'] as String? ?? '',
              mainText: structured['main_text'] as String? ?? '',
              secondaryText: structured['secondary_text'] as String? ?? '',
            );
          }).toList() ??
          [];

      return Success(predictions);
    } catch (e, st) {
      log('fetchAutocompleteSuggestions failed', error: e, stackTrace: st, name: 'LocationPicker');
      return Failure(ApiErrorModel(message: 'فشل البحث'));
    }
  }
}
