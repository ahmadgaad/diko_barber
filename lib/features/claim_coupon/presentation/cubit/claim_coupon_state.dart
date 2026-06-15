import 'package:zain/features/claim_coupon/domain/entities/coupon_eligible_package.dart';
import 'package:zain/features/claim_coupon/domain/entities/coupon_eligible_service.dart';

sealed class ClaimCouponState {
  const ClaimCouponState();
}

class ClaimCouponLoading extends ClaimCouponState {
  const ClaimCouponLoading();
}

class ClaimCouponError extends ClaimCouponState {
  const ClaimCouponError({required this.message});
  final String message;
}

class ClaimCouponData extends ClaimCouponState {
  const ClaimCouponData({
    required this.couponId,
    required this.couponCode,
    required this.couponName,
    required this.salonName,
    required this.step,
    required this.services,
    required this.packages,
    this.selectedServiceIds = const {},
    this.selectedPackageIds = const {},
  });

  final int couponId;
  final String couponCode;
  final String couponName;
  final String salonName;
  final int step;
  final List<CouponEligibleService> services;
  final List<CouponEligiblePackage> packages;
  final Set<int> selectedServiceIds;
  final Set<int> selectedPackageIds;

  bool get canProceed =>
      selectedServiceIds.isNotEmpty || selectedPackageIds.isNotEmpty;
  bool get hasItems => services.isNotEmpty || packages.isNotEmpty;

  List<CouponEligibleService> get selectedServices =>
      services.where((s) => selectedServiceIds.contains(s.id)).toList();

  List<CouponEligiblePackage> get selectedPackages =>
      packages.where((p) => selectedPackageIds.contains(p.id)).toList();

  ClaimCouponData copyWith({
    int? step,
    Set<int>? selectedServiceIds,
    Set<int>? selectedPackageIds,
  }) {
    return ClaimCouponData(
      couponId: couponId,
      couponCode: couponCode,
      couponName: couponName,
      salonName: salonName,
      step: step ?? this.step,
      services: services,
      packages: packages,
      selectedServiceIds: selectedServiceIds ?? this.selectedServiceIds,
      selectedPackageIds: selectedPackageIds ?? this.selectedPackageIds,
    );
  }
}
