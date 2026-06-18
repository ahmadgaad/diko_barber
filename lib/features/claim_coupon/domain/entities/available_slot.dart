class AvailableSlot {
  const AvailableSlot({
    required this.startTime,
    required this.endTime,
    this.staffId,
  });

  final String startTime;
  final String endTime;
  final int? staffId;
}
