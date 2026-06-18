import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../data_sources/checkout_remote_data_source.dart';
import '../models/payment_method_model.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  const CheckoutRepositoryImpl(this._dataSource);

  final CheckoutRemoteDataSource _dataSource;

  @override
  Future<Result<ApiErrorModel, List<PaymentMethod>>> getPaymentMethods() async {
    try {
      final response = await _dataSource.getPaymentMethods();
      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }
      final methods = (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map(PaymentMethodModel.fromJson)
          .toList();
      return Success(methods);
    } catch (_) {
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }
}
