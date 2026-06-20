import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/booking/domain/entities/appointment_filter.dart';
import 'package:zain/features/booking/domain/entities/bookings_page.dart';

abstract class BookingsRepository {
  Future<Result<ApiErrorModel, List<AppointmentFilter>>>
      getAppointmentStatuses();

  Future<Result<ApiErrorModel, BookingsPage>> getAppointments({
    required int filter,
    int page = 1,
  });

  Future<Result<ApiErrorModel, void>> cancelAppointment({
    required int appointmentId,
    required String reason,
  });
}
