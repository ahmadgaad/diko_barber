import 'package:zain/core/shared/domain/entities/booking.dart';

sealed class BookingsState {
  const BookingsState();
}

class BookingsLoading extends BookingsState {
  const BookingsLoading();
}

class BookingsLoaded extends BookingsState {
  const BookingsLoaded({
    required this.all,
    required this.filtered,
    this.selectedStatus,
  });

  final List<Booking> all;
  final List<Booking> filtered;
  final BookingStatus? selectedStatus; // null = "All"

  BookingsLoaded copyWith({
    List<Booking>? all,
    List<Booking>? filtered,
    BookingStatus? Function()? selectedStatus,
  }) {
    return BookingsLoaded(
      all: all ?? this.all,
      filtered: filtered ?? this.filtered,
      selectedStatus: selectedStatus != null
          ? selectedStatus()
          : this.selectedStatus,
    );
  }
}

class BookingsError extends BookingsState {
  const BookingsError();
}
