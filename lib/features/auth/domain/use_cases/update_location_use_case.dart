import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';

import '../repositories/auth_repository.dart';

class UpdateLocationUseCase {
  const UpdateLocationUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<ApiErrorModel, void>> call({
    required double lat,
    required double long,
    required String location,
  }) =>
      _repository.updateLocation(lat: lat, long: long, location: location);
}
