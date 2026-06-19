import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/core/shared/domain/entities/booking.dart';
import 'package:zain/features/booking/domain/entities/appointment_filter.dart';

abstract class BookingsRepository {
  Future<Result<ApiErrorModel, List<AppointmentFilter>>>
      getAppointmentStatuses();

  Future<Result<ApiErrorModel, List<Booking>>> getAppointments({
    required int filter,
  });
}
