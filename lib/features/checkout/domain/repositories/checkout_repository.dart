import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import '../entities/payment_method.dart';

abstract interface class CheckoutRepository {
  Future<Result<ApiErrorModel, List<PaymentMethod>>> getPaymentMethods();
}
