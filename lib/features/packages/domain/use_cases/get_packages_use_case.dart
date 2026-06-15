import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/core/shared/domain/entities/nearest_packages_params.dart';
import 'package:zain/features/packages/domain/entities/packages_page.dart';
import 'package:zain/features/packages/domain/repositories/packages_repository.dart';

class GetPackagesUseCase {
  const GetPackagesUseCase(this._repository);
  final PackagesRepository _repository;

  Future<Result<ApiErrorModel, PackagesPage>> call(
    NearestPackagesParams params,
  ) =>
      _repository.getPackages(params);
}
