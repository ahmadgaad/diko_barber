import 'package:zain/core/networking/api_consumer.dart';
import 'package:zain/core/networking/api_response.dart';
import 'package:zain/core/networking/endpoints.dart';

abstract class BookingScheduleRemoteDataSource {
  Future<ApiResponse<dynamic>> createAppointment({
    required int salonId,
    required String appointmentDate,
    required String startTime,
    required int staffId,
    required List<int> serviceIds,
    required List<int> packageIds,
  });
}

class BookingScheduleRemoteDataSourceImpl
    implements BookingScheduleRemoteDataSource {
  const BookingScheduleRemoteDataSourceImpl(this._networkService);

  final INetworkService _networkService;

  @override
  Future<ApiResponse<dynamic>> createAppointment({
    required int salonId,
    required String appointmentDate,
    required String startTime,
    required int staffId,
    required List<int> serviceIds,
    required List<int> packageIds,
  }) {
    final services = [
      ...serviceIds.map((id) => {'service_id': id}),
      ...packageIds.map((id) => {'package_id': id}),
    ];
    return _networkService.postData(
      endPoint: EndPoints.appointments,
      body: {
        'salon_id': salonId,
        'appointment_date': appointmentDate,
        'start_time': startTime,
        'booking_type': 0,
        'staff_id': staffId,
        'user_address_id': null,
        'services': services,
      },
    );
  }
}
