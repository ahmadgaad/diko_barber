import 'appointment_status.dart';

class AppointmentFilter {
  const AppointmentFilter({
    required this.filter,
    required this.name,
    required this.statuses,
  });

  final int filter;
  final String name;
  final List<AppointmentStatus> statuses;

  List<int> get statusIds => statuses.map((s) => s.id).toList();
}
