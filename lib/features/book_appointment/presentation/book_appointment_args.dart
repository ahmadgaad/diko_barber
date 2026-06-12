class BookAppointmentArgs {
  const BookAppointmentArgs({
    required this.salonId,
    required this.salonName,
    this.couponCode,
  });

  final int salonId;
  final String salonName;
  final String? couponCode;
}
