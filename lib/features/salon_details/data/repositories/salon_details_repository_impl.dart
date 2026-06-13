import 'dart:developer';

import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/features/salon_details/data/data_sources/salon_details_remote_data_source.dart';
import 'package:ronaq_barber/features/salon_details/data/models/salon_details_model.dart';
import 'package:ronaq_barber/features/salon_details/domain/entities/salon_details.dart';
import 'package:ronaq_barber/features/salon_details/domain/repositories/salon_details_repository.dart';

class SalonDetailsRepositoryImpl implements SalonDetailsRepository {
  const SalonDetailsRepositoryImpl(this._remoteDataSource);

  final SalonDetailsRemoteDataSource _remoteDataSource;

  @override
  Future<Result<ApiErrorModel, SalonDetails>> getSalonDetails(
    int id, {
    double? lat,
    double? long,
  }) async {
    try {
      final query = <String, dynamic>{};
      if (lat != null) query['lat'] = lat.toString();
      if (long != null) query['long'] = long.toString();

      final response = await _remoteDataSource.getSalonDetails(id, query);

      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }

      return Success(
        SalonDetailsModel.fromJson(response.data as Map<String, dynamic>),
      );
    } catch (e, st) {
      log(
        'getSalonDetails failed',
        error: e,
        stackTrace: st,
        name: 'SalonDetailsRepository',
      );
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }
}
