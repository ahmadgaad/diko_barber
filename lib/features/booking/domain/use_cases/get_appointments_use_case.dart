import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/core/shared/domain/entities/booking.dart';
import 'package:zain/features/booking/domain/repositories/bookings_repository.dart';

class GetAppointmentsUseCase {
  const GetAppointmentsUseCase(this._repository);

  final BookingsRepository _repository;

  Future<Result<ApiErrorModel, List<Booking>>> call({
    required int filter,
  }) =>
      _repository.getAppointments(filter: filter);
}
