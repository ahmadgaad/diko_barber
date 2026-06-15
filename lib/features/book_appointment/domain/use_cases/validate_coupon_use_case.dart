import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/book_appointment/domain/entities/coupon_validation.dart';
import 'package:zain/features/book_appointment/domain/repositories/book_appointment_repository.dart';

class ValidateCouponUseCase {
  const ValidateCouponUseCase(this._repository);

  final BookAppointmentRepository _repository;

  Future<Result<ApiErrorModel, CouponValidation>> call({
    required String code,
    required int salonId,
    required int serviceId,
  }) =>
      _repository.validateCoupon(
        code: code,
        salonId: salonId,
        serviceId: serviceId,
      );
}
