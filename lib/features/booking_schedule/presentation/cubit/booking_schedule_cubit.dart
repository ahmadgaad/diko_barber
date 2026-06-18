import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zain/features/book_appointment/domain/entities/staff_member.dart';
import 'package:zain/features/claim_coupon/domain/entities/available_slot.dart';
import 'package:zain/features/claim_coupon/domain/use_cases/get_available_barbers_use_case.dart';
import 'package:zain/features/claim_coupon/domain/use_cases/get_available_slots_use_case.dart';
import '../../domain/use_cases/create_appointment_use_case.dart';
import 'booking_schedule_state.dart';

class BookingScheduleCubit extends Cubit<BookingScheduleState> {
  BookingScheduleCubit({
    required GetAvailableSlotsUseCase getAvailableSlots,
    required GetAvailableBarbersUseCase getAvailableBarbers,
    required CreateAppointmentUseCase createAppointment,
    required int salonId,
    required String salonName,
    required List<int> serviceIds,
    required List<int> packageIds,
    String? couponCode,
  })  : _getAvailableSlots = getAvailableSlots,
        _getAvailableBarbers = getAvailableBarbers,
        _createAppointment = createAppointment,
        super(BookingScheduleForm(
          salonId: salonId,
          salonName: salonName,
          serviceIds: serviceIds,
          packageIds: packageIds,
          couponCode: couponCode,
          selectedDate: DateTime.now(),
          isLoadingSlots: true,
        )) {
    _loadSlots(DateTime.now());
  }

  final GetAvailableSlotsUseCase _getAvailableSlots;
  final GetAvailableBarbersUseCase _getAvailableBarbers;
  final CreateAppointmentUseCase _createAppointment;

  Future<void> selectDate(DateTime date) async {
    final current = state;
    if (current is! BookingScheduleForm) return;
    emit(current.copyWith(
      selectedDate: date,
      isLoadingSlots: true,
      availableSlots: [],
      selectedSlot: () => null,
      availableBarbers: [],
      selectedBarber: () => null,
      slotsError: () => null,
    ));
    _loadSlots(date);
  }

  Future<void> _loadSlots(DateTime date) async {
    final current = state;
    if (current is! BookingScheduleForm) return;
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final result = await _getAvailableSlots(
      salonId: current.salonId,
      date: dateStr,
      serviceIds: current.serviceIds,
      packageIds: current.packageIds,
    );
    if (isClosed) return;
    final latest = state;
    if (latest is! BookingScheduleForm) return;
    result.when(
      success: (slots) => emit(latest.copyWith(
        isLoadingSlots: false,
        availableSlots: slots,
        slotsError: () => null,
      )),
      failure: (error) => emit(latest.copyWith(
        isLoadingSlots: false,
        slotsError: () => error.message,
      )),
    );
  }

  Future<void> selectSlot(AvailableSlot slot) async {
    final current = state;
    if (current is! BookingScheduleForm) return;
    emit(current.copyWith(
      selectedSlot: () => slot,
      isLoadingBarbers: true,
      availableBarbers: [],
      selectedBarber: () => null,
      barbersError: () => null,
    ));
    final dateStr = DateFormat('yyyy-MM-dd').format(current.selectedDate!);
    final result = await _getAvailableBarbers(
      salonId: current.salonId,
      date: dateStr,
      startTime: slot.startTime,
      serviceIds: current.serviceIds,
      packageIds: current.packageIds,
    );
    if (isClosed) return;
    final latest = state;
    if (latest is! BookingScheduleForm) return;
    result.when(
      success: (barbers) => emit(latest.copyWith(
        isLoadingBarbers: false,
        availableBarbers: barbers,
        barbersError: () => null,
      )),
      failure: (error) => emit(latest.copyWith(
        isLoadingBarbers: false,
        barbersError: () => error.message,
      )),
    );
  }

  void selectBarber(StaffMember barber) {
    final current = state;
    if (current is! BookingScheduleForm) return;
    emit(current.copyWith(selectedBarber: () => barber));
  }

  Future<void> confirmBooking() async {
    final current = state;
    if (current is! BookingScheduleForm) return;
    if (!current.canConfirm) return;

    emit(current.copyWith(isSubmitting: true, apiError: () => null));

    final dateStr =
        DateFormat('yyyy-MM-dd').format(current.selectedDate!);
    final result = await _createAppointment(
      salonId: current.salonId,
      appointmentDate: dateStr,
      startTime: current.selectedSlot!.startTime,
      staffId: current.selectedBarber!.id,
      serviceIds: current.serviceIds,
      packageIds: current.packageIds,
    );
    if (isClosed) return;
    result.when(
      success: (appointment) =>
          emit(BookingScheduleSuccess(appointment: appointment)),
      failure: (error) {
        final latest = state;
        if (latest is! BookingScheduleForm) return;
        emit(latest.copyWith(
          isSubmitting: false,
          apiError: () => error.message,
        ));
      },
    );
  }
}
