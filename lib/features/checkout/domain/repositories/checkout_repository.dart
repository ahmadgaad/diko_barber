import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import '../entities/payment_method.dart';
import '../entities/payment_result.dart';

abstract interface class CheckoutRepository {
  Future<Result<ApiErrorModel, List<PaymentMethod>>> getPaymentMethods();

  Future<Result<ApiErrorModel, PaymentResult>> payAppointment({
    required int appointmentId,
    required int paymentMethodId,
  });
}
