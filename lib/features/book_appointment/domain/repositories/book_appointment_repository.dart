import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/book_appointment/domain/entities/appointment_service.dart';
import 'package:zain/features/book_appointment/domain/entities/book_appointment_params.dart';
import 'package:zain/features/book_appointment/domain/entities/coupon_validation.dart';
import 'package:zain/features/book_appointment/domain/entities/staff_member.dart';
import 'package:zain/features/book_appointment/domain/entities/time_slot.dart';

abstract class BookAppointmentRepository {
  Future<Result<ApiErrorModel, List<AppointmentService>>> getSalonServices(
    int salonId,
  );

  Future<Result<ApiErrorModel, List<StaffMember>>> getStaff(int salonId);

  Future<Result<ApiErrorModel, List<TimeSlot>>> getTimeSlots({
    required int salonId,
    required DateTime date,
    required int serviceId,
    int? staffId,
  });

  Future<Result<ApiErrorModel, CouponValidation>> validateCoupon({
    required String code,
    required int salonId,
    required int serviceId,
  });

  Future<Result<ApiErrorModel, int>> createBooking(
    BookAppointmentParams params,
  );
}
