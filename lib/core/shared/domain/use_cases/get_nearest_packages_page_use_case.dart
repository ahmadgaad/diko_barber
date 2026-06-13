import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/core/shared/domain/entities/nearest_packages_page.dart';
import 'package:ronaq_barber/core/shared/domain/entities/nearest_packages_params.dart';
import 'package:ronaq_barber/core/shared/domain/repositories/shared_repository.dart';

class GetNearestPackagesPageUseCase {
  const GetNearestPackagesPageUseCase(this._repository);

  final SharedRepository _repository;

  Future<Result<ApiErrorModel, NearestPackagesPage>> call(
    NearestPackagesParams params,
  ) =>
      _repository.getNearestPackagesPage(params);
}
