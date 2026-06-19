import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/booking/domain/entities/appointment_filter.dart';
import 'package:zain/features/booking/domain/repositories/bookings_repository.dart';

class GetAppointmentStatusesUseCase {
  const GetAppointmentStatusesUseCase(this._repository);

  final BookingsRepository _repository;

  Future<Result<ApiErrorModel, List<AppointmentFilter>>> call() =>
      _repository.getAppointmentStatuses();
}
