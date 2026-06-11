import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/core/shared/data/data_sources/shared_remote_data_source.dart';
import 'package:ronaq_barber/core/shared/data/models/banner_model.dart';
import 'package:ronaq_barber/core/shared/data/models/category_model.dart';
import 'package:ronaq_barber/core/shared/data/models/city_model.dart';
import 'package:ronaq_barber/core/shared/data/models/neighborhood_model.dart';
import 'package:ronaq_barber/core/shared/domain/entities/banner.dart';
import 'package:ronaq_barber/core/shared/domain/entities/category.dart';
import 'package:ronaq_barber/core/shared/domain/entities/city.dart';
import 'package:ronaq_barber/core/shared/domain/entities/neighborhood.dart';
import 'package:ronaq_barber/core/shared/domain/repositories/shared_repository.dart';

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
}
