import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import '../entities/favorite_type.dart';

import '../entities/banner.dart';
import '../entities/category.dart';
import '../entities/city.dart';
import '../entities/coupon.dart';
import '../entities/nearest_coupons_params.dart';
import '../entities/nearest_package.dart';
import '../entities/nearest_packages_page.dart';
import '../entities/nearest_packages_params.dart';
import '../entities/nearest_salons_params.dart';
import '../entities/nearest_service.dart';
import '../entities/nearest_services_params.dart';
import '../entities/neighborhood.dart';
import '../entities/favorites_tab_result.dart';
import '../entities/package_details.dart';
import '../entities/salon_details.dart';
import '../entities/salons_page.dart';

abstract class SharedRepository {
  Future<Result<ApiErrorModel, List<City>>> getCities();
  Future<Result<ApiErrorModel, List<Neighborhood>>> getNeighborhoods({
    required int cityId,
  });
  Future<Result<ApiErrorModel, List<Category>>> getCategories({
    int? specialization,
  });
  Future<Result<ApiErrorModel, List<Banner>>> getBanners();
  Future<Result<ApiErrorModel, SalonsPage>> getNearestSalons(
    NearestSalonsParams params,
  );
  Future<Result<ApiErrorModel, List<Coupon>>> getNearestCoupons(
    NearestCouponsParams params,
  );
  Future<Result<ApiErrorModel, List<NearestPackage>>> getNearestPackages(
    NearestPackagesParams params,
  );
  Future<Result<ApiErrorModel, NearestPackagesPage>> getNearestPackagesPage(
    NearestPackagesParams params,
  );
  Future<Result<ApiErrorModel, List<NearestService>>> getNearestServices(
    NearestServicesParams params,
  );
  Future<Result<ApiErrorModel, PackageDetails>> getPackageDetails(int id);
  Future<Result<ApiErrorModel, SalonDetails>> getSalonDetails(
    int id, {
    double? lat,
    double? long,
  });
  Future<Result<ApiErrorModel, void>> toggleFavorite({
    required int id,
    required FavoriteType type,
  });
  Future<Result<ApiErrorModel, FavoritesTabResult>> getFavorites(FavoriteType type);
}
