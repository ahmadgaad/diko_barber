import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/features/packages/domain/entities/package_details.dart';
import 'package:ronaq_barber/features/packages/domain/repositories/packages_repository.dart';

class GetPackageDetailsUseCase {
  const GetPackageDetailsUseCase(this._repository);
  final PackagesRepository _repository;

  Future<Result<ApiErrorModel, PackageDetails>> call(int id) =>
      _repository.getPackageDetails(id);
}
