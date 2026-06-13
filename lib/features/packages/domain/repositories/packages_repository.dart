import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/core/shared/domain/entities/nearest_packages_params.dart';
import 'package:ronaq_barber/features/packages/domain/entities/package_details.dart';
import 'package:ronaq_barber/features/packages/domain/entities/packages_page.dart';

abstract class PackagesRepository {
  Future<Result<ApiErrorModel, PackagesPage>> getPackages(
    NearestPackagesParams params,
  );

  Future<Result<ApiErrorModel, PackageDetails>> getPackageDetails(int id);
}
