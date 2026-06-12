import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';

import '../entities/city.dart';
import '../repositories/shared_repository.dart';

class GetCitiesUseCase {
  const GetCitiesUseCase(this._repository);

  final SharedRepository _repository;

  Future<Result<ApiErrorModel, List<City>>> call() => _repository.getCities();
}
