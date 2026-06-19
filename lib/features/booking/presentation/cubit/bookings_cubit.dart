import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/features/booking/domain/use_cases/get_appointment_statuses_use_case.dart';
import 'package:zain/features/booking/domain/use_cases/get_appointments_use_case.dart';
import 'package:zain/features/booking/presentation/cubit/bookings_state.dart';

class BookingsCubit extends Cubit<BookingsState> {
  BookingsCubit(
    this._getAppointmentStatusesUseCase,
    this._getAppointmentsUseCase,
  ) : super(const BookingsLoading());

  final GetAppointmentStatusesUseCase _getAppointmentStatusesUseCase;
  final GetAppointmentsUseCase _getAppointmentsUseCase;
  bool _isLoading = false;

  Future<void> refresh() async {
    if (_isLoading) return;

    final current = state;

    if (current is BookingsLoaded) {
      emit(current.copyWith(isLoadingBookings: true));
      await _fetchBookings(current.selectedFilter.filter);
      return;
    }

    await _load();
  }

  Future<void> _load() async {
    _isLoading = true;
    emit(const BookingsLoading());

    final statusResult = await _getAppointmentStatusesUseCase();
    if (isClosed) return;

    final filters = statusResult.getOrNull();
    if (filters == null || filters.isEmpty) {
      _isLoading = false;
      emit(const BookingsError());
      return;
    }

    final bookingsResult = await _getAppointmentsUseCase(
      filter: filters.first.filter,
    );
    _isLoading = false;
    if (isClosed) return;

    final bookings = bookingsResult.getOrNull();

    emit(BookingsLoaded(
      filters: filters,
      bookings: bookings ?? const [],
    ));
  }

  Future<void> selectFilter(int index) async {
    final current = state;
    if (current is! BookingsLoaded) return;
    if (current.selectedFilterIndex == index) return;

    final filter = current.filters[index];

    emit(current.copyWith(
      selectedFilterIndex: index,
      isLoadingBookings: true,
      bookings: const [],
    ));

    await _fetchBookings(filter.filter);
  }

  Future<void> _fetchBookings(int filter) async {
    final result = await _getAppointmentsUseCase(filter: filter);

    _isLoading = false;

    if (isClosed) return;

    final current = state;
    if (current is! BookingsLoaded) return;

    result.when(
      failure: (_) => emit(current.copyWith(
        isLoadingBookings: false,
        bookings: const [],
      )),
      success: (bookings) => emit(current.copyWith(
        isLoadingBookings: false,
        bookings: bookings,
      )),
    );

  }
}
