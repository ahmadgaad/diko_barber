import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/core/shared/domain/entities/nearest_service.dart';
import 'package:zain/core/shared/domain/entities/nearest_services_params.dart';
import 'package:zain/core/shared/domain/repositories/shared_repository.dart';

class GetNearestServicesUseCase {
  const GetNearestServicesUseCase(this._repository);

  final SharedRepository _repository;

  Future<Result<ApiErrorModel, List<NearestService>>> call(
    NearestServicesParams params,
  ) =>
      _repository.getNearestServices(params);
}
