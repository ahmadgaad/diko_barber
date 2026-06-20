import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/booking/domain/repositories/bookings_repository.dart';

class CancelAppointmentUseCase {
  const CancelAppointmentUseCase(this._repository);

  final BookingsRepository _repository;

  Future<Result<ApiErrorModel, void>> call({
    required int appointmentId,
    required String reason,
  }) =>
      _repository.cancelAppointment(
        appointmentId: appointmentId,
        reason: reason,
      );
}
