import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/book_appointment/domain/entities/staff_member.dart';
import 'package:zain/features/book_appointment/domain/repositories/book_appointment_repository.dart';

class GetStaffUseCase {
  const GetStaffUseCase(this._repository);

  final BookAppointmentRepository _repository;

  Future<Result<ApiErrorModel, List<StaffMember>>> call(int salonId) =>
      _repository.getStaff(salonId);
}
