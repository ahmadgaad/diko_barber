enum BookingStatus { pending, confirmed, completed, cancelled }

class Booking {
  const Booking({
    required this.id,
    required this.salonName,
    required this.salonLogo,
    required this.serviceName,
    required this.price,
    required this.dateTime,
    required this.status,
    this.staffName,
    this.address,
  });

  final int id;
  final String salonName;
  final String salonLogo;
  final String serviceName;
  final double price;
  final DateTime dateTime;
  final BookingStatus status;
  final String? staffName;
  final String? address;
}
