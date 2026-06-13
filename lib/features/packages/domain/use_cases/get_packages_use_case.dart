import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/core/shared/domain/entities/nearest_packages_params.dart';
import 'package:ronaq_barber/features/packages/domain/entities/packages_page.dart';
import 'package:ronaq_barber/features/packages/domain/repositories/packages_repository.dart';

class GetPackagesUseCase {
  const GetPackagesUseCase(this._repository);
  final PackagesRepository _repository;

  Future<Result<ApiErrorModel, PackagesPage>> call(
    NearestPackagesParams params,
  ) =>
      _repository.getPackages(params);
}
