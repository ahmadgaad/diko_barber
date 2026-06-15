import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/core/shared/domain/entities/nearest_packages_params.dart';
import 'package:zain/features/packages/domain/entities/package_details.dart';
import 'package:zain/features/packages/domain/entities/packages_page.dart';

abstract class PackagesRepository {
  Future<Result<ApiErrorModel, PackagesPage>> getPackages(
    NearestPackagesParams params,
  );

  Future<Result<ApiErrorModel, PackageDetails>> getPackageDetails(int id);
}
