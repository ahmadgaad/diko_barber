import 'dart:developer';

import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/core/shared/data/data_sources/shared_remote_data_source.dart';
import 'package:zain/core/shared/data/models/banner_model.dart';
import 'package:zain/core/shared/data/models/category_model.dart';
import 'package:zain/core/shared/data/models/city_model.dart';
import 'package:zain/core/shared/data/models/neighborhood_model.dart';
import 'package:zain/core/shared/data/models/salon_model.dart';
import 'package:zain/core/shared/domain/entities/banner.dart';
import 'package:zain/core/shared/domain/entities/category.dart';
import 'package:zain/core/shared/domain/entities/city.dart';
import 'package:zain/core/shared/data/models/coupon_model.dart';
import 'package:zain/core/shared/data/models/nearest_package_model.dart';
import 'package:zain/core/shared/data/models/nearest_service_model.dart';
import 'package:zain/core/shared/domain/entities/coupon.dart';
import 'package:zain/core/shared/domain/entities/nearest_coupons_params.dart';
import 'package:zain/core/shared/domain/entities/nearest_package.dart';
import 'package:zain/core/shared/domain/entities/nearest_packages_page.dart';
import 'package:zain/core/shared/domain/entities/nearest_packages_params.dart';
import 'package:zain/core/shared/domain/entities/nearest_salons_params.dart';
import 'package:zain/core/shared/domain/entities/nearest_service.dart';
import 'package:zain/core/shared/domain/entities/nearest_services_params.dart';
import 'package:zain/core/shared/domain/entities/neighborhood.dart';
import 'package:zain/core/shared/domain/entities/salons_page.dart';
import 'package:zain/core/shared/domain/entities/favorite_type.dart';
import 'package:zain/core/shared/domain/entities/favorites_tab_result.dart';
import 'package:zain/core/shared/domain/repositories/shared_repository.dart';

class SharedRepositoryImpl implements SharedRepository {
  const SharedRepositoryImpl(this._remoteDataSource);

  final SharedRemoteDataSource _remoteDataSource;

  @override
  Future<Result<ApiErrorModel, List<City>>> getCities() async {
    try {
      final response = await _remoteDataSource.getCities();

      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }

      final cities = (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map(CityModel.fromJson)
          .toList();

      return Success(cities);
    } catch (_) {
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Result<ApiErrorModel, List<Category>>> getCategories({
    int? specialization,
  }) async {
    try {
      final response = await _remoteDataSource.getCategories(
        specialization: specialization,
      );

      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }

      final categories = (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map(CategoryModel.fromJson)
          .toList();

      return Success(categories);
    } catch (_) {
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Result<ApiErrorModel, List<Neighborhood>>> getNeighborhoods({
    required int cityId,
  }) async {
    try {
      final response = await _remoteDataSource.getNeighborhoods(
        cityId: cityId,
      );

      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }

      final neighborhoods = (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map(NeighborhoodModel.fromJson)
          .toList();

      return Success(neighborhoods);
    } catch (_) {
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Result<ApiErrorModel, List<Banner>>> getBanners() async {
    try {
      final response = await _remoteDataSource.getBanners();

      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }

      final banners = (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map(BannerModel.fromJson)
          .toList();

      return Success(banners);
    } catch (_) {
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Result<ApiErrorModel, SalonsPage>> getNearestSalons(
    NearestSalonsParams params,
  ) async {
    try {
      final query = <String, dynamic>{
        'is_home': params.isHome ? '1' : '0',
        'page': params.page.toString(),
        'per_page': params.perPage.toString(),
      };
      if (params.lat != null) query['lat'] = params.lat.toString();
      if (params.long != null) query['long'] = params.long.toString();
      if (params.search != null && params.search!.isNotEmpty) {
        query['search'] = params.search;
      }
      if (params.categoryIds != null && params.categoryIds!.isNotEmpty) {
        query['category_ids[]'] = params.categoryIds!.map((e) => e.toString()).toList();
      }
      if (params.sortBy != null && params.sortBy!.isNotEmpty) {
        query['sort_by[]'] = params.sortBy;
      }

      final response = await _remoteDataSource.getNearestSalons(query);

      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }

      final salons = (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map(SalonModel.fromJson)
          .toList();

      return Success(SalonsPage(
        salons: salons,
        hasMore: response.pagination?.hasNextPage ?? false,
      ));
    } catch (e, st) {
      log('getNearestSalons failed', error: e, stackTrace: st, name: 'SharedRepository');
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Result<ApiErrorModel, List<Coupon>>> getNearestCoupons(
    NearestCouponsParams params,
  ) async {
    try {
      final query = <String, dynamic>{
        'page': params.page.toString(),
        'per_page': params.perPage.toString(),
      };
      if (params.lat != null) query['lat'] = params.lat.toString();
      if (params.long != null) query['long'] = params.long.toString();

      final response = await _remoteDataSource.getNearestCoupons(query);

      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }

      final coupons = (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map(CouponModel.fromJson)
          .toList();

      return Success(coupons);
    } catch (e, st) {
      log('getNearestCoupons failed', error: e, stackTrace: st, name: 'SharedRepository');
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Result<ApiErrorModel, List<NearestPackage>>> getNearestPackages(
    NearestPackagesParams params,
  ) async {
    try {
      final response = await _remoteDataSource
          .getNearestPackages(_packagesQuery(params));

      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }

      final packages = (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map(NearestPackageModel.fromJson)
          .toList();

      return Success(packages);
    } catch (e, st) {
      log('getNearestPackages failed', error: e, stackTrace: st, name: 'SharedRepository');
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Result<ApiErrorModel, List<NearestService>>> getNearestServices(
    NearestServicesParams params,
  ) async {
    try {
      final query = <String, dynamic>{
        'page': params.page.toString(),
        'per_page': params.perPage.toString(),
      };
      if (params.lat != null) query['lat'] = params.lat.toString();
      if (params.long != null) query['long'] = params.long.toString();

      final response = await _remoteDataSource.getNearestServices(query);

      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }

      final services = (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map(NearestServiceModel.fromJson)
          .toList();

      return Success(services);
    } catch (e, st) {
      log('getNearestServices failed', error: e, stackTrace: st, name: 'SharedRepository');
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Result<ApiErrorModel, NearestPackagesPage>> getNearestPackagesPage(
    NearestPackagesParams params,
  ) async {
    try {
      final response = await _remoteDataSource
          .getNearestPackages(_packagesQuery(params));

      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }

      final packages = (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map(NearestPackageModel.fromJson)
          .toList();

      return Success(NearestPackagesPage(
        packages: packages,
        hasMore: response.pagination?.hasNextPage ?? false,
      ));
    } catch (e, st) {
      log('getNearestPackagesPage failed', error: e, stackTrace: st, name: 'SharedRepository');
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Result<ApiErrorModel, FavoritesTabResult>> getFavorites(
    FavoriteType type,
  ) async {
    try {
      final response = await _remoteDataSource.getFavorites(type.value);
      if (response.isError || response.data == null) {
        return Failure(ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'));
      }
      final list = (response.data as List).whereType<Map<String, dynamic>>();
      return switch (type) {
        FavoriteType.salon => Success(
            SalonFavoritesResult(list.map(SalonModel.fromJson).toList()),
          ),
        FavoriteType.package => Success(
            PackageFavoritesResult(
                list.map(NearestPackageModel.fromJson).toList()),
          ),
        FavoriteType.service => Success(
            ServiceFavoritesResult(
                list.map(NearestServiceModel.fromJson).toList()),
          ),
      };
    } catch (e, st) {
      log('getFavorites failed', error: e, stackTrace: st, name: 'SharedRepository');
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Result<ApiErrorModel, void>> toggleFavorite({
    required int id,
    required FavoriteType type,
  }) async {
    try {
      final response = await _remoteDataSource.toggleFavorite(
        id: id,
        type: type.value,
      );

      if (response.isError) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }

      return const Success(null);
    } catch (e, st) {
      log('toggleFavorite failed', error: e, stackTrace: st, name: 'SharedRepository');
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  Map<String, dynamic> _packagesQuery(NearestPackagesParams params) {
    final query = <String, dynamic>{
      'page': params.page.toString(),
      'per_page': params.perPage.toString(),
      'is_home': params.isHome ? '1' : '0',
    };
    if (params.lat != null) query['lat'] = params.lat.toString();
    if (params.long != null) query['long'] = params.long.toString();
    if (params.search != null && params.search!.isNotEmpty) {
      query['search'] = params.search;
    }
    for (final id in params.categoryIds) {
      query['category_ids[]'] = id.toString();
    }
    for (final s in params.sortBy) {
      query['sort_by[]'] = s;
    }
    return query;
  }
}
