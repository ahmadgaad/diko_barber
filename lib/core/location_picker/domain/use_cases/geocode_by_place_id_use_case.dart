import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/core/location_picker/domain/entities/geocoding_result.dart';
import 'package:zain/core/location_picker/domain/repositories/location_picker_repository.dart';

class GeocodeByPlaceIdUseCase {
  const GeocodeByPlaceIdUseCase(this._repository);

  final LocationPickerRepository _repository;

  Future<Result<ApiErrorModel, GeocodingResult>> call({
    required String placeId,
  }) =>
      _repository.geocodeByPlaceId(placeId);
}
