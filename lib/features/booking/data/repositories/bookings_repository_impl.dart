import 'dart:developer';

import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/booking/data/data_sources/bookings_remote_data_source.dart';
import 'package:zain/features/booking/data/models/appointment_filter_model.dart';
import 'package:zain/features/booking/data/models/booking_model.dart';
import 'package:zain/features/booking/domain/entities/appointment_filter.dart';
import 'package:zain/features/booking/domain/entities/bookings_page.dart';
import 'package:zain/features/booking/domain/repositories/bookings_repository.dart';

class BookingsRepositoryImpl implements BookingsRepository {
  const BookingsRepositoryImpl(this._remoteDataSource);

  final BookingsRemoteDataSource _remoteDataSource;

  @override
  Future<Result<ApiErrorModel, List<AppointmentFilter>>>
      getAppointmentStatuses() async {
    try {
      final response = await _remoteDataSource.getAppointmentStatuses();

      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }

      final filters = (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map(AppointmentFilterModel.fromJson)
          .toList();

      return Success(filters);
    } catch (e, st) {
      log(
        'getAppointmentStatuses failed',
        error: e,
        stackTrace: st,
        name: 'BookingsRepository',
      );
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Result<ApiErrorModel, BookingsPage>> getAppointments({
    required int filter,
    int page = 1,
  }) async {
    try {
      final response = await _remoteDataSource.getAppointments({
        'filter': filter,
        'page': page,
      });

      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }

      final bookings = (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map(BookingModel.fromJson)
          .toList();

      return Success(BookingsPage(
        bookings: bookings,
        hasMore: response.pagination?.hasNextPage ?? false,
      ));
    } catch (e, st) {
      log(
        'getAppointments failed',
        error: e,
        stackTrace: st,
        name: 'BookingsRepository',
      );
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Result<ApiErrorModel, void>> cancelAppointment({
    required int appointmentId,
    required String reason,
  }) async {
    try {
      final response = await _remoteDataSource.cancelAppointment(
        appointmentId: appointmentId,
        reason: reason,
      );

      if (response.isError) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }

      return const Success(null);
    } catch (e, st) {
      log(
        'cancelAppointment failed',
        error: e,
        stackTrace: st,
        name: 'BookingsRepository',
      );
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }
}
