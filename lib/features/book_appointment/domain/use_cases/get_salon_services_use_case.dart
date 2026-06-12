import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/features/book_appointment/domain/entities/appointment_service.dart';
import 'package:ronaq_barber/features/book_appointment/domain/repositories/book_appointment_repository.dart';

class GetSalonServicesUseCase {
  const GetSalonServicesUseCase(this._repository);

  final BookAppointmentRepository _repository;

  Future<Result<ApiErrorModel, List<AppointmentService>>> call(
    int salonId,
  ) =>
      _repository.getSalonServices(salonId);
}
