class BookingScheduleArgs {
  const BookingScheduleArgs({
    required this.salonId,
    required this.salonName,
    required this.serviceIds,
    required this.packageIds,
    this.couponCode,
  });

  final int salonId;
  final String salonName;
  final Set<int> serviceIds;
  final Set<int> packageIds;
  final String? couponCode;
}
