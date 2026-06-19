import 'package:zain/core/networking/api_consumer.dart';
import 'package:zain/core/networking/api_response.dart';
import 'package:zain/core/networking/endpoints.dart';

abstract class BookingsRemoteDataSource {
  Future<ApiResponse<dynamic>> getAppointmentStatuses();
  Future<ApiResponse<dynamic>> getAppointments(
      Map<String, dynamic> queryParams);
}

class BookingsRemoteDataSourceImpl implements BookingsRemoteDataSource {
  const BookingsRemoteDataSourceImpl(this._networkService);

  final INetworkService _networkService;

  @override
  Future<ApiResponse<dynamic>> getAppointmentStatuses() =>
      _networkService.getData(endPoint: EndPoints.appointmentStatuses);

  @override
  Future<ApiResponse<dynamic>> getAppointments(
    Map<String, dynamic> queryParams,
  ) =>
      _networkService.getData(
        endPoint: EndPoints.appointmentsList,
        queryParameters: queryParams,
      );
}
