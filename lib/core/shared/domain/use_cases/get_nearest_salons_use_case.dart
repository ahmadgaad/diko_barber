import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/core/shared/domain/entities/nearest_salons_params.dart';
import 'package:zain/core/shared/domain/entities/salons_page.dart';
import 'package:zain/core/shared/domain/repositories/shared_repository.dart';

class GetNearestSalonsUseCase {
  const GetNearestSalonsUseCase(this._repository);

  final SharedRepository _repository;

  Future<Result<ApiErrorModel, SalonsPage>> call(
    NearestSalonsParams params,
  ) =>
      _repository.getNearestSalons(params);
}
