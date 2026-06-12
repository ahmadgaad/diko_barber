import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/features/book_appointment/domain/entities/staff_member.dart';
import 'package:ronaq_barber/features/book_appointment/domain/repositories/book_appointment_repository.dart';

class GetStaffUseCase {
  const GetStaffUseCase(this._repository);

  final BookAppointmentRepository _repository;

  Future<Result<ApiErrorModel, List<StaffMember>>> call(int salonId) =>
      _repository.getStaff(salonId);
}
