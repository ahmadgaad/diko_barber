import 'dart:developer';

import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/booking_schedule/data/models/created_appointment_model.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/payment_result.dart';
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

  @override
  Future<Result<ApiErrorModel, PaymentResult>> payAppointment({
    required int appointmentId,
    required int paymentMethodId,
  }) async {
    try {
      final response = await _dataSource.payAppointment(
        appointmentId: appointmentId,
        paymentMethodId: paymentMethodId,
      );

      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }

      final data = response.data as Map<String, dynamic>;

      if (data.containsKey('checkout_url')) {
        return Success(PaymentRedirect(
          checkoutUrl: data['checkout_url'] as String,
          returnUrl: data['return_url'] as String,
        ));
      }

      return Success(PaymentSuccess(
        appointment: CreatedAppointmentModel.fromJson(data),
      ));
    } catch (e, st) {
      log(
        'payAppointment failed',
        error: e,
        stackTrace: st,
        name: 'CheckoutRepository',
      );
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }
}
