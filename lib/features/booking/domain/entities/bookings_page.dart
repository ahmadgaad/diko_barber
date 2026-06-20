import 'package:zain/core/shared/domain/entities/booking.dart';

class BookingsPage {
  const BookingsPage({
    required this.bookings,
    required this.hasMore,
  });

  final List<Booking> bookings;
  final bool hasMore;
}
