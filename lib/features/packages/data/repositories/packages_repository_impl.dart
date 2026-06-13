import 'dart:developer';

import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/core/shared/data/models/nearest_package_model.dart';
import 'package:ronaq_barber/core/shared/domain/entities/nearest_packages_params.dart';
import 'package:ronaq_barber/features/packages/data/data_sources/packages_remote_data_source.dart';
import 'package:ronaq_barber/features/packages/data/models/package_details_model.dart';
import 'package:ronaq_barber/features/packages/domain/entities/package_details.dart';
import 'package:ronaq_barber/features/packages/domain/entities/packages_page.dart';
import 'package:ronaq_barber/features/packages/domain/repositories/packages_repository.dart';

class PackagesRepositoryImpl implements PackagesRepository {
  const PackagesRepositoryImpl(this._remoteDataSource);

  final PackagesRemoteDataSource _remoteDataSource;

  @override
  Future<Result<ApiErrorModel, PackagesPage>> getPackages(
    NearestPackagesParams params,
  ) async {
    try {
      final response = await _remoteDataSource.getPackages(params);

      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }

      final packages = (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map(NearestPackageModel.fromJson)
          .toList();

      return Success(
        PackagesPage(
          packages: packages,
          hasMore: response.pagination?.hasNextPage ?? false,
        ),
      );
    } catch (e, st) {
      log('getPackages failed', error: e, stackTrace: st, name: 'PackagesRepository');
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Result<ApiErrorModel, PackageDetails>> getPackageDetails(int id) async {
    try {
      final response = await _remoteDataSource.getPackageDetails(id);

      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }

      return Success(
        PackageDetailsModel.fromJson(response.data as Map<String, dynamic>),
      );
    } catch (e, st) {
      log('getPackageDetails failed', error: e, stackTrace: st, name: 'PackagesRepository');
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }
}
