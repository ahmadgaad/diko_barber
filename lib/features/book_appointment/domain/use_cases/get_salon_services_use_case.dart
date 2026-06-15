import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/book_appointment/domain/entities/appointment_service.dart';
import 'package:zain/features/book_appointment/domain/repositories/book_appointment_repository.dart';

class GetSalonServicesUseCase {
  const GetSalonServicesUseCase(this._repository);

  final BookAppointmentRepository _repository;

  Future<Result<ApiErrorModel, List<AppointmentService>>> call(
    int salonId,
  ) =>
      _repository.getSalonServices(salonId);
}
