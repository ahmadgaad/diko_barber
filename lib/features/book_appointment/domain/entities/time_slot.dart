class TimeSlot {
  const TimeSlot({
    required this.id,
    required this.time,
    required this.isAvailable,
  });

  final int id;
  final String time;
  final bool isAvailable;
}
