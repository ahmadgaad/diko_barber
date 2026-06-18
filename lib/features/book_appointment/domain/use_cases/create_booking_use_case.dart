import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/book_appointment/domain/entities/book_appointment_params.dart';
import 'package:zain/features/book_appointment/domain/repositories/book_appointment_repository.dart';
import 'package:zain/features/booking_schedule/domain/entities/created_appointment.dart';

class CreateBookingUseCase {
  const CreateBookingUseCase(this._repository);

  final BookAppointmentRepository _repository;

  Future<Result<ApiErrorModel, CreatedAppointment>> call(
    BookAppointmentParams params,
  ) =>
      _repository.createBooking(params);
}
