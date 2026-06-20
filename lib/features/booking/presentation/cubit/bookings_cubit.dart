import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/booking/domain/use_cases/cancel_appointment_use_case.dart';
import 'package:zain/features/booking/domain/use_cases/get_appointment_statuses_use_case.dart';
import 'package:zain/features/booking/domain/use_cases/get_appointments_use_case.dart';
import 'package:zain/features/booking/presentation/cubit/bookings_state.dart';

class BookingsCubit extends Cubit<BookingsState> {
  BookingsCubit(
    this._getAppointmentStatusesUseCase,
    this._getAppointmentsUseCase,
    this._cancelAppointmentUseCase,
  ) : super(const BookingsLoading());

  static bool pendingRefresh = false;

  final GetAppointmentStatusesUseCase _getAppointmentStatusesUseCase;
  final GetAppointmentsUseCase _getAppointmentsUseCase;
  final CancelAppointmentUseCase _cancelAppointmentUseCase;
  bool _isLoading = false;

  Future<void> refreshIfNeeded() async {
    if (!pendingRefresh) return;
    pendingRefresh = false;
    await refresh();
  }

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

    final page = bookingsResult.getOrNull();

    emit(BookingsLoaded(
      filters: filters,
      bookings: page?.bookings ?? const [],
      currentPage: 1,
      hasMore: page?.hasMore ?? false,
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

  Future<void> loadMore() async {
    final current = state;
    if (current is! BookingsLoaded) return;
    if (!current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));

    final nextPage = current.currentPage + 1;
    final result = await _getAppointmentsUseCase(
      filter: current.selectedFilter.filter,
      page: nextPage,
    );

    if (isClosed) return;

    final latest = state;
    if (latest is! BookingsLoaded) return;

    result.when(
      failure: (_) => emit(latest.copyWith(isLoadingMore: false)),
      success: (page) => emit(latest.copyWith(
        bookings: [...latest.bookings, ...page.bookings],
        currentPage: nextPage,
        hasMore: page.hasMore,
        isLoadingMore: false,
      )),
    );
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
        currentPage: 1,
        hasMore: false,
      )),
      success: (page) => emit(current.copyWith(
        isLoadingBookings: false,
        bookings: page.bookings,
        currentPage: 1,
        hasMore: page.hasMore,
      )),
    );
  }

  Future<Result<ApiErrorModel, void>> cancelAppointment({
    required int appointmentId,
    required String reason,
  }) async {
    final result = await _cancelAppointmentUseCase(
      appointmentId: appointmentId,
      reason: reason,
    );

    if (result.isSuccess) {
      pendingRefresh = true;
      await refresh();
    }

    return result;
  }
}
