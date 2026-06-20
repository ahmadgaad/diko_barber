import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import '../../domain/entities/created_appointment.dart';
import '../../domain/repositories/booking_schedule_repository.dart';
import '../data_sources/booking_schedule_remote_data_source.dart';
import '../models/created_appointment_model.dart';

class BookingScheduleRepositoryImpl implements BookingScheduleRepository {
  const BookingScheduleRepositoryImpl(this._dataSource);

  final BookingScheduleRemoteDataSource _dataSource;

  @override
  Future<Result<ApiErrorModel, CreatedAppointment>> createAppointment({
    required int salonId,
    required String appointmentDate,
    required String startTime,
    required int staffId,
    required List<int> serviceIds,
    required List<int> packageIds,
    int? couponId,
  }) async {
    try {
      final response = await _dataSource.createAppointment(
        salonId: salonId,
        appointmentDate: appointmentDate,
        startTime: startTime,
        staffId: staffId,
        serviceIds: serviceIds,
        packageIds: packageIds,
        couponId: couponId,
      );
      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }
      final data = response.data as Map<String, dynamic>;
      return Success(CreatedAppointmentModel.fromJson(data));
    } catch (_) {
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }
}
