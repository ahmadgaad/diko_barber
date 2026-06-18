import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import '../entities/payment_method.dart';
import '../repositories/checkout_repository.dart';

class GetPaymentMethodsUseCase {
  const GetPaymentMethodsUseCase(this._repository);

  final CheckoutRepository _repository;

  Future<Result<ApiErrorModel, List<PaymentMethod>>> call() =>
      _repository.getPaymentMethods();
}
