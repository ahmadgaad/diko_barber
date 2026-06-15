import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/features/claim_coupon/domain/use_cases/get_coupon_eligible_items_use_case.dart';
import 'claim_coupon_state.dart';

class ClaimCouponCubit extends Cubit<ClaimCouponState> {
  ClaimCouponCubit(this._getEligibleItems) : super(const ClaimCouponLoading());

  final GetCouponEligibleItemsUseCase _getEligibleItems;

  Future<void> load({
    required int couponId,
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
    emit(current.copyWith(step: step));
  }
}
