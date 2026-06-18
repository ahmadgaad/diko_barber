import 'package:intl/intl.dart';
import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/book_appointment/data/data_sources/book_appointment_remote_data_source.dart';
import 'package:zain/features/book_appointment/data/models/appointment_service_model.dart';
import 'package:zain/features/book_appointment/data/models/coupon_validation_model.dart';
import 'package:zain/features/book_appointment/data/models/staff_member_model.dart';
import 'package:zain/features/book_appointment/data/models/time_slot_model.dart';
import 'package:zain/features/book_appointment/domain/entities/appointment_service.dart';
import 'package:zain/features/book_appointment/domain/entities/book_appointment_params.dart';
import 'package:zain/features/book_appointment/domain/entities/coupon_validation.dart';
import 'package:zain/features/book_appointment/domain/entities/staff_member.dart';
import 'package:zain/features/book_appointment/domain/entities/time_slot.dart';
import 'package:zain/features/book_appointment/domain/repositories/book_appointment_repository.dart';
import 'package:zain/features/booking_schedule/data/models/created_appointment_model.dart';
import 'package:zain/features/booking_schedule/domain/entities/created_appointment.dart';

class BookAppointmentRepositoryImpl implements BookAppointmentRepository {
  const BookAppointmentRepositoryImpl(this._dataSource);

  final BookAppointmentRemoteDataSource _dataSource;

  @override
  Future<Result<ApiErrorModel, List<AppointmentService>>> getSalonServices(
    int salonId,
  ) async {
    try {
      final response = await _dataSource.getSalonServices(salonId);
      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }
      final services = (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map(AppointmentServiceModel.fromJson)
          .toList();
      return Success(services);
    } catch (_) {
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Result<ApiErrorModel, List<StaffMember>>> getStaff(
    int salonId,
  ) async {
    try {
      final response = await _dataSource.getStaff(salonId);
      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }
      final staff = (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map(StaffMemberModel.fromJson)
          .toList();
      return Success(staff);
    } catch (_) {
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Result<ApiErrorModel, List<TimeSlot>>> getTimeSlots({
    required int salonId,
    required DateTime date,
    required int serviceId,
    int? staffId,
  }) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final response = await _dataSource.getTimeSlots(
        salonId: salonId,
        date: formattedDate,
        serviceId: serviceId,
        staffId: staffId,
      );
      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }
      final slots = (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map(TimeSlotModel.fromJson)
          .toList();
      return Success(slots);
    } catch (_) {
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Result<ApiErrorModel, CouponValidation>> validateCoupon({
    required String code,
    required int salonId,
    required int serviceId,
  }) async {
    try {
      final response = await _dataSource.validateCoupon(
        code: code,
        salonId: salonId,
        serviceId: serviceId,
      );
      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }
      final validation = CouponValidationModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      return Success(validation);
    } catch (_) {
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Result<ApiErrorModel, CreatedAppointment>> createBooking(
    BookAppointmentParams params,
  ) async {
    try {
      final body = <String, dynamic>{
        'salon_id': params.salonId,
        'service_id': params.serviceId,
        'date': DateFormat('yyyy-MM-dd').format(params.date),
        'slot_id': params.slotId,
        if (params.staffId != null) 'staff_id': params.staffId,
        if (params.couponCode != null) 'coupon_code': params.couponCode,
      };
      final response = await _dataSource.createBooking(body);
      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }
      final data = response.data as Map<String, dynamic>;
      return Success(CreatedAppointmentModel.fromJson(data));
    } catch (_) {
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }
}
