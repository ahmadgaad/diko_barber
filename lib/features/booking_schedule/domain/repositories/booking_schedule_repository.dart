import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import '../entities/created_appointment.dart';

abstract interface class BookingScheduleRepository {
  Future<Result<ApiErrorModel, CreatedAppointment>> createAppointment({
    required int salonId,
    required String appointmentDate,
    required String startTime,
    required int staffId,
    required List<int> serviceIds,
    required List<int> packageIds,
  });
}
