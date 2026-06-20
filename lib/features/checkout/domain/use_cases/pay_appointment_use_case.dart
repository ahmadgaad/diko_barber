import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import '../entities/payment_result.dart';
import '../repositories/checkout_repository.dart';

class PayAppointmentUseCase {
  const PayAppointmentUseCase(this._repository);

  final CheckoutRepository _repository;

  Future<Result<ApiErrorModel, PaymentResult>> call({
    required int appointmentId,
    required int paymentMethodId,
  }) =>
      _repository.payAppointment(
        appointmentId: appointmentId,
        paymentMethodId: paymentMethodId,
      );
}
