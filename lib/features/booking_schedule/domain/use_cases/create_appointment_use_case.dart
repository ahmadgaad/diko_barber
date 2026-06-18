import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import '../entities/created_appointment.dart';
import '../repositories/booking_schedule_repository.dart';

class CreateAppointmentUseCase {
  const CreateAppointmentUseCase(this._repository);

  final BookingScheduleRepository _repository;

  Future<Result<ApiErrorModel, CreatedAppointment>> call({
    required int salonId,
    required String appointmentDate,
    required String startTime,
    required int staffId,
    required List<int> serviceIds,
    required List<int> packageIds,
  }) =>
      _repository.createAppointment(
        salonId: salonId,
        appointmentDate: appointmentDate,
        startTime: startTime,
        staffId: staffId,
        serviceIds: serviceIds,
        packageIds: packageIds,
      );
}
