import 'package:zain/core/location_picker/domain/entities/geocoding_result.dart';
import 'package:zain/core/location_picker/domain/entities/place_prediction.dart';

sealed class LocationPickerState {
  const LocationPickerState();
}

class LocationPickerInitial extends LocationPickerState {
  const LocationPickerInitial();
}

class LocationPickerGpsLoading extends LocationPickerState {
  const LocationPickerGpsLoading();
}

class LocationPickerGpsLoaded extends LocationPickerState {
  const LocationPickerGpsLoaded({required this.lat, required this.lng});

  final double lat;
  final double lng;
}

class LocationPickerGpsError extends LocationPickerState {
  const LocationPickerGpsError();
}

class LocationPickerGeocoding extends LocationPickerState {
  const LocationPickerGeocoding({this.lastResult});

  final GeocodingResult? lastResult;
}

class LocationPickerGeocoded extends LocationPickerState {
  const LocationPickerGeocoded(this.result);

  final GeocodingResult result;
}

class LocationPickerGeocodingError extends LocationPickerState {
  const LocationPickerGeocodingError(this.message);

  final String message;
}

class LocationPickerSearching extends LocationPickerState {
  const LocationPickerSearching();
}

class LocationPickerSuggestions extends LocationPickerState {
  const LocationPickerSuggestions(this.predictions, {required this.query});

  final List<PlacePrediction> predictions;
  final String query;
}

class LocationPickerSearchCleared extends LocationPickerState {
  const LocationPickerSearchCleared();
}
