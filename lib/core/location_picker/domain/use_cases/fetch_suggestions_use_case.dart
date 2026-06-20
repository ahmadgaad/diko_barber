import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/core/location_picker/domain/entities/place_prediction.dart';
import 'package:zain/core/location_picker/domain/repositories/location_picker_repository.dart';

class FetchSuggestionsUseCase {
  const FetchSuggestionsUseCase(this._repository);

  final LocationPickerRepository _repository;

  Future<Result<ApiErrorModel, List<PlacePrediction>>> call({
    required String query,
  }) =>
      _repository.fetchAutocompleteSuggestions(query);
}
