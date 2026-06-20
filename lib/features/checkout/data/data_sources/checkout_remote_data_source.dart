import 'dart:io';

import 'package:zain/core/networking/api_consumer.dart';
import 'package:zain/core/networking/api_response.dart';
import 'package:zain/core/networking/endpoints.dart';

abstract class CheckoutRemoteDataSource {
  Future<ApiResponse<dynamic>> getPaymentMethods();
  Future<ApiResponse<dynamic>> payAppointment({
    required int appointmentId,
    required int paymentMethodId,
  });
}

class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  const CheckoutRemoteDataSourceImpl(this._networkService);

  final INetworkService _networkService;

  @override
  Future<ApiResponse<dynamic>> getPaymentMethods() {
    return _networkService.getData(
      endPoint: EndPoints.paymentMethods,
      queryParameters: {
        'is_android': Platform.isAndroid ? 1 : 0,
      },
    );
  }

  @override
  Future<ApiResponse<dynamic>> payAppointment({
    required int appointmentId,
    required int paymentMethodId,
  }) {
    return _networkService.postData(
      endPoint: EndPoints.payAppointment(appointmentId),
      body: {'payment_method': paymentMethodId},
    );
  }
}
