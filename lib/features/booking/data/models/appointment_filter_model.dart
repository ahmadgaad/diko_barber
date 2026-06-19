import 'package:zain/features/booking/domain/entities/appointment_filter.dart';

import 'appointment_status_model.dart';

class AppointmentFilterModel extends AppointmentFilter {
  const AppointmentFilterModel({
    required super.filter,
    required super.name,
    required super.statuses,
  });

  factory AppointmentFilterModel.fromJson(Map<String, dynamic> json) {
    final statusesList = (json['statuses'] as List)
        .whereType<Map<String, dynamic>>()
        .map(AppointmentStatusModel.fromJson)
        .toList();

    return AppointmentFilterModel(
      filter: json['filter'] as int,
      name: json['name'] as String,
      statuses: statusesList,
    );
  }
}
