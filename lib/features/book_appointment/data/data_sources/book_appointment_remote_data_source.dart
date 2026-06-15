import 'package:zain/core/networking/api_consumer.dart';
import 'package:zain/core/networking/api_response.dart';
import 'package:zain/core/networking/endpoints.dart';

abstract class BookAppointmentRemoteDataSource {
  Future<ApiResponse<dynamic>> getSalonServices(int salonId);

  Future<ApiResponse<dynamic>> getStaff(int salonId);

  Future<ApiResponse<dynamic>> getTimeSlots({
    required int salonId,
    required String date,
    required int serviceId,
    int? staffId,
  });

  Future<ApiResponse<dynamic>> validateCoupon({
    required String code,
    required int salonId,
    required int serviceId,
  });

  Future<ApiResponse<dynamic>> createBooking(Map<String, dynamic> body);
}

class BookAppointmentRemoteDataSourceImpl
    implements BookAppointmentRemoteDataSource {
  const BookAppointmentRemoteDataSourceImpl(this._networkService);

  final INetworkService _networkService;

  @override
  Future<ApiResponse<dynamic>> getSalonServices(int salonId) =>
      _networkService.getData(
        endPoint: EndPoints.salonServices(salonId),
      );

  @override
  Future<ApiResponse<dynamic>> getStaff(int salonId) =>
      _networkService.getData(
        endPoint: EndPoints.salonStaff(salonId),
      );

  @override
  Future<ApiResponse<dynamic>> getTimeSlots({
    required int salonId,
    required String date,
    required int serviceId,
    int? staffId,
  }) {
    final params = <String, dynamic>{
      'date': date,
      'service_id': serviceId,
      'staff_id': ?staffId,
    };
    return _networkService.getData(
      endPoint: EndPoints.salonSlots(salonId),
      queryParameters: params,
    );
  }

  @override
  Future<ApiResponse<dynamic>> validateCoupon({
    required String code,
    required int salonId,
    required int serviceId,
  }) =>
      _networkService.postData(
        endPoint: EndPoints.validateCoupon,
        body: {
          'code': code,
          'salon_id': salonId,
          'service_id': serviceId,
        },
      );

  @override
  Future<ApiResponse<dynamic>> createBooking(Map<String, dynamic> body) =>
      _networkService.postData(
        endPoint: EndPoints.createBooking,
        body: body,
      );
}
