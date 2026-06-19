import 'package:zain/core/shared/domain/entities/booking.dart';
import 'package:zain/features/booking/domain/entities/appointment_filter.dart';

sealed class BookingsState {
  const BookingsState();
}

class BookingsLoading extends BookingsState {
  const BookingsLoading();
}

class BookingsLoaded extends BookingsState {
  const BookingsLoaded({
    required this.filters,
    required this.bookings,
    this.selectedFilterIndex = 0,
    this.isLoadingBookings = false,
  });

  final List<AppointmentFilter> filters;
  final List<Booking> bookings;
  final int selectedFilterIndex;
  final bool isLoadingBookings;

  AppointmentFilter get selectedFilter => filters[selectedFilterIndex];

  BookingsLoaded copyWith({
    List<AppointmentFilter>? filters,
    List<Booking>? bookings,
    int? selectedFilterIndex,
    bool? isLoadingBookings,
  }) {
    return BookingsLoaded(
      filters: filters ?? this.filters,
      bookings: bookings ?? this.bookings,
      selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex,
      isLoadingBookings: isLoadingBookings ?? this.isLoadingBookings,
    );
  }
}

class BookingsError extends BookingsState {
  const BookingsError();
}
