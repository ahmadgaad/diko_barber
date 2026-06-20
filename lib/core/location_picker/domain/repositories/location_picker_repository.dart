import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/core/location_picker/domain/entities/geocoding_result.dart';
import 'package:zain/core/location_picker/domain/entities/place_prediction.dart';

abstract class LocationPickerRepository {
  Future<Result<ApiErrorModel, GeocodingResult>> reverseGeocode(
    double lat,
    double lng,
  );

  Future<Result<ApiErrorModel, GeocodingResult>> geocodeByPlaceId(
    String placeId,
  );

  Future<Result<ApiErrorModel, List<PlacePrediction>>>
      fetchAutocompleteSuggestions(String query);
}
