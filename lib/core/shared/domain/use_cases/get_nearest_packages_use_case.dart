import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/core/shared/domain/entities/nearest_package.dart';
import 'package:ronaq_barber/core/shared/domain/entities/nearest_packages_params.dart';
import 'package:ronaq_barber/core/shared/domain/repositories/shared_repository.dart';

class GetNearestPackagesUseCase {
  const GetNearestPackagesUseCase(this._repository);

  final SharedRepository _repository;

  Future<Result<ApiErrorModel, List<NearestPackage>>> call(
    NearestPackagesParams params,
  ) =>
      _repository.getNearestPackages(params);
}
