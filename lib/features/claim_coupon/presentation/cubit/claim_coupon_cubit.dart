import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zain/features/book_appointment/domain/entities/staff_member.dart';
import 'package:zain/features/claim_coupon/domain/entities/available_slot.dart';
import 'package:zain/features/claim_coupon/domain/use_cases/get_available_barbers_use_case.dart';
import 'package:zain/features/claim_coupon/domain/use_cases/get_available_slots_use_case.dart';
import 'package:zain/features/claim_coupon/domain/use_cases/get_coupon_eligible_items_use_case.dart';
import 'claim_coupon_state.dart';

class ClaimCouponCubit extends Cubit<ClaimCouponState> {
  ClaimCouponCubit(
    this._getEligibleItems,
    this._getAvailableSlots,
    this._getAvailableBarbers,
  ) : super(const ClaimCouponLoading());

  final GetCouponEligibleItemsUseCase _getEligibleItems;
  final GetAvailableSlotsUseCase _getAvailableSlots;
  final GetAvailableBarbersUseCase _getAvailableBarbers;

  Future<void> load({
    required int couponId,
    required int salonId,
    required String couponCode,
    required String couponName,
    required String salonName,
  }) async {
    emit(const ClaimCouponLoading());
    final result = await _getEligibleItems(couponId);
    if (isClosed) return;
    result.when(
      success: (items) => emit(ClaimCouponData(
        couponId: couponId,
        salonId: salonId,
        couponCode: couponCode,
        couponName: couponName,
        salonName: salonName,
        step: 1,
        services: items.services,
        packages: items.packages,
      )),
      failure: (error) => emit(ClaimCouponError(message: error.message)),
    );
  }

  void toggleService(int serviceId) {
    final current = state;
    if (current is! ClaimCouponData) return;
    final updated = Set<int>.from(current.selectedServiceIds);
    if (updated.contains(serviceId)) {
      updated.remove(serviceId);
    } else {
      updated.add(serviceId);
    }
    emit(current.copyWith(selectedServiceIds: updated));
  }

  void togglePackage(int packageId) {
    final current = state;
    if (current is! ClaimCouponData) return;
    final updated = Set<int>.from(current.selectedPackageIds);
    if (updated.contains(packageId)) {
      updated.remove(packageId);
    } else {
      updated.add(packageId);
    }
    emit(current.copyWith(selectedPackageIds: updated));
  }

  void goToStep(int step) {
    final current = state;
    if (current is! ClaimCouponData) return;
    if (step == 2 && current.selectedDate == null) {
      final today = DateTime.now();
      emit(current.copyWith(step: step, selectedDate: today));
      _loadSlots(current, today);
      return;
    }
    emit(current.copyWith(step: step));
  }

  Future<void> selectDate(DateTime date) async {
    final current = state;
    if (current is! ClaimCouponData) return;
    emit(current.copyWith(
      selectedDate: date,
      isLoadingSlots: true,
      availableSlots: [],
      selectedSlot: () => null,
      availableBarbers: [],
      selectedBarber: () => null,
      slotsError: () => null,
    ));
    _loadSlots(current, date);
  }

  Future<void> _loadSlots(ClaimCouponData data, DateTime date) async {
    final current = state;
    if (current is! ClaimCouponData) return;
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final result = await _getAvailableSlots(
      salonId: data.salonId,
      date: dateStr,
      serviceIds: data.selectedServiceIdsList,
      packageIds: data.selectedPackageIdsList,
    );
    if (isClosed) return;
    final latest = state;
    if (latest is! ClaimCouponData) return;
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
    if (current is! ClaimCouponData) return;
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
      serviceIds: current.selectedServiceIdsList,
      packageIds: current.selectedPackageIdsList,
    );
    if (isClosed) return;
    final latest = state;
    if (latest is! ClaimCouponData) return;
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

  void selectBarber(StaffMember? barber) {
    final current = state;
    if (current is! ClaimCouponData) return;
    emit(current.copyWith(selectedBarber: () => barber));
  }
}
