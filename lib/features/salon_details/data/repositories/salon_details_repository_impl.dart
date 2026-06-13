import 'dart:developer';

import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/features/salon_details/data/data_sources/salon_details_remote_data_source.dart';
import 'package:ronaq_barber/features/salon_details/data/models/gallery_image_model.dart';
import 'package:ronaq_barber/features/salon_details/data/models/rating_model.dart';
import 'package:ronaq_barber/features/salon_details/data/models/salon_details_model.dart';
import 'package:ronaq_barber/features/salon_details/domain/entities/rating_stats.dart';
import 'package:ronaq_barber/features/salon_details/domain/entities/review.dart';
import 'package:ronaq_barber/features/salon_details/domain/entities/salon_details.dart';
import 'package:ronaq_barber/features/salon_details/domain/entities/salon_gallery_page.dart';
import 'package:ronaq_barber/features/salon_details/domain/entities/salon_ratings_page.dart';
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

  @override
  Future<Result<ApiErrorModel, SalonGalleryPage>> getSalonGallery(
    int id, {
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final response = await _remoteDataSource.getSalonGallery(id, {
        'page': page,
        'per_page': perPage,
      });

      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }

      final images = (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map(GalleryImageModel.fromJson)
          .toList();

      return Success(
        SalonGalleryPage(
          images: images,
          hasMore: response.pagination?.hasNextPage ?? false,
        ),
      );
    } catch (e, st) {
      log(
        'getSalonGallery failed',
        error: e,
        stackTrace: st,
        name: 'SalonDetailsRepository',
      );
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Result<ApiErrorModel, SalonRatingsPage>> getSalonRatings(
    int id, {
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final response = await _remoteDataSource.getSalonRatings(id, {
        'page': page,
        'per_page': perPage,
      });

      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }

      final data = response.data as Map<String, dynamic>;
      final statsJson = data['stats'] as Map<String, dynamic>? ?? {};
      final stats = RatingStats(
        one: statsJson['one'] as int? ?? 0,
        two: statsJson['two'] as int? ?? 0,
        three: statsJson['three'] as int? ?? 0,
        four: statsJson['four'] as int? ?? 0,
        five: statsJson['five'] as int? ?? 0,
      );

      final ratingsJson =
          (data['ratings'] as List?)?.whereType<Map<String, dynamic>>() ??
              const [];
      final ratings = ratingsJson
          .map<Review>(RatingModel.fromJson)
          .toList();

      return Success(
        SalonRatingsPage(
          stats: stats,
          ratings: ratings,
          hasMore: response.pagination?.hasNextPage ?? false,
        ),
      );
    } catch (e, st) {
      log(
        'getSalonRatings failed',
        error: e,
        stackTrace: st,
        name: 'SalonDetailsRepository',
      );
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }
}
