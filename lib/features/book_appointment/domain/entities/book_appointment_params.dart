class BookAppointmentParams {
  const BookAppointmentParams({
    required this.salonId,
    required this.serviceId,
    required this.date,
    required this.slotId,
    this.staffId,
    this.couponCode,
  });

  final int salonId;
  final int serviceId;
  final DateTime date;
  final int slotId;
  final int? staffId;
  final String? couponCode;
}
