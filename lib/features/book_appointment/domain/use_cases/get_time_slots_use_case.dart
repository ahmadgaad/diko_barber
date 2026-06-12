import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/features/book_appointment/domain/entities/time_slot.dart';
import 'package:ronaq_barber/features/book_appointment/domain/repositories/book_appointment_repository.dart';

class GetTimeSlotsUseCase {
  const GetTimeSlotsUseCase(this._repository);

  final BookAppointmentRepository _repository;

  Future<Result<ApiErrorModel, List<TimeSlot>>> call({
    required int salonId,
    required DateTime date,
    required int serviceId,
    int? staffId,
  }) =>
      _repository.getTimeSlots(
        salonId: salonId,
        date: date,
        serviceId: serviceId,
        staffId: staffId,
      );
}
