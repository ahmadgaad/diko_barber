import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';

import '../entities/neighborhood.dart';
import '../repositories/shared_repository.dart';

class GetNeighborhoodsUseCase {
  const GetNeighborhoodsUseCase(this._repository);

  final SharedRepository _repository;

  Future<Result<ApiErrorModel, List<Neighborhood>>> call({
    required int cityId,
  }) => _repository.getNeighborhoods(cityId: cityId);
}
