class BookAppointmentArgs {
  const BookAppointmentArgs({
    required this.salonId,
    required this.salonName,
    this.couponCode,
    this.serviceIds = const {},
    this.packageIds = const {},
  });

  final int salonId;
  final String salonName;
  final String? couponCode;
  final Set<int> serviceIds;
  final Set<int> packageIds;
}
