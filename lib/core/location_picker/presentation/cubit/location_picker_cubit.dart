import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/services/location_service.dart';
import 'package:zain/core/location_picker/domain/use_cases/fetch_suggestions_use_case.dart';
import 'package:zain/core/location_picker/domain/use_cases/geocode_by_place_id_use_case.dart';
import 'package:zain/core/location_picker/domain/use_cases/reverse_geocode_use_case.dart';
import 'package:zain/core/location_picker/domain/entities/place_prediction.dart';
import 'package:zain/core/location_picker/presentation/cubit/location_picker_state.dart';

class LocationPickerCubit extends Cubit<LocationPickerState> {
  LocationPickerCubit({
    required ReverseGeocodeUseCase reverseGeocodeUseCase,
    required FetchSuggestionsUseCase fetchSuggestionsUseCase,
    required GeocodeByPlaceIdUseCase geocodeByPlaceIdUseCase,
    required LocationService locationService,
  })  : _reverseGeocode = reverseGeocodeUseCase,
        _fetchSuggestions = fetchSuggestionsUseCase,
        _geocodeByPlaceId = geocodeByPlaceIdUseCase,
        _locationService = locationService,
        super(const LocationPickerInitial());

  final ReverseGeocodeUseCase _reverseGeocode;
  final FetchSuggestionsUseCase _fetchSuggestions;
  final GeocodeByPlaceIdUseCase _geocodeByPlaceId;
  final LocationService _locationService;

  Future<void> autoFetchIfPermissionGranted() async {
    final position = await _locationService.getCurrentPosition();
    if (isClosed || position == null) return;
    emit(LocationPickerGpsLoaded(
      lat: position.latitude,
      lng: position.longitude,
    ));
  }

  Future<void> fetchCurrentLocation() async {
    emit(const LocationPickerGpsLoading());
    final position = await _locationService.getCurrentPosition();
    if (isClosed) return;
    if (position == null) {
      emit(const LocationPickerGpsError());
      return;
    }
    emit(LocationPickerGpsLoaded(
      lat: position.latitude,
      lng: position.longitude,
    ));
  }

  Future<void> reverseGeocode(double lat, double lng) async {
    final last = state is LocationPickerGeocoded
        ? (state as LocationPickerGeocoded).result
        : null;
    emit(LocationPickerGeocoding(lastResult: last));

    final result = await _reverseGeocode(lat: lat, lng: lng);
    if (isClosed) return;

    result.when(
      success: (data) => emit(LocationPickerGeocoded(data)),
      failure: (error) => emit(LocationPickerGeocodingError(error.message)),
    );
  }

  Future<void> fetchSuggestions(String query) async {
    if (query.trim().isEmpty) return;
    emit(const LocationPickerSearching());

    final result = await _fetchSuggestions(query: query);
    if (isClosed) return;

    result.when(
      success: (data) =>
          emit(LocationPickerSuggestions(data, query: query)),
      failure: (error) =>
          emit(LocationPickerGeocodingError(error.message)),
    );
  }

  Future<void> selectPrediction(PlacePrediction prediction) async {
    final last = state is LocationPickerGeocoded
        ? (state as LocationPickerGeocoded).result
        : null;
    emit(LocationPickerGeocoding(lastResult: last));

    final result = await _geocodeByPlaceId(placeId: prediction.placeId);
    if (isClosed) return;

    result.when(
      success: (data) => emit(LocationPickerGeocoded(data)),
      failure: (error) => emit(LocationPickerGeocodingError(error.message)),
    );
  }

  void clearSuggestions() => emit(const LocationPickerSearchCleared());
}
