import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/booking/domain/entities/bookings_page.dart';
import 'package:zain/features/booking/domain/repositories/bookings_repository.dart';

class GetAppointmentsUseCase {
  const GetAppointmentsUseCase(this._repository);

  final BookingsRepository _repository;

  Future<Result<ApiErrorModel, BookingsPage>> call({
    required int filter,
    int page = 1,
  }) =>
      _repository.getAppointments(filter: filter, page: page);
}
