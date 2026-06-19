import 'package:zain/features/booking/domain/entities/appointment_status.dart';

class AppointmentStatusModel extends AppointmentStatus {
  const AppointmentStatusModel({required super.id, required super.name});

  factory AppointmentStatusModel.fromJson(Map<String, dynamic> json) {
    return AppointmentStatusModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
