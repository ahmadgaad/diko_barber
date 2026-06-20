import 'package:zain/features/book_appointment/domain/entities/staff_member.dart';
import 'package:zain/features/booking_schedule/domain/entities/created_appointment.dart';
import 'package:zain/features/claim_coupon/domain/entities/available_slot.dart';
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
    required this.salonId,
    required this.couponCode,
    required this.couponName,
    required this.salonName,
    required this.step,
    required this.services,
    required this.packages,
    this.selectedServiceIds = const {},
    this.selectedPackageIds = const {},
    this.selectedDate,
    this.availableSlots = const [],
    this.isLoadingSlots = false,
    this.slotsError,
    this.selectedSlot,
    this.availableBarbers = const [],
    this.isLoadingBarbers = false,
    this.barbersError,
    this.selectedBarber,
    this.isSubmitting = false,
    this.apiError,
  });

  final int couponId;
  final int salonId;
  final String couponCode;
  final String couponName;
  final String salonName;
  final int step;
  final List<CouponEligibleService> services;
  final List<CouponEligiblePackage> packages;
  final Set<int> selectedServiceIds;
  final Set<int> selectedPackageIds;

  // Step 2 — schedule
  final DateTime? selectedDate;
  final List<AvailableSlot> availableSlots;
  final bool isLoadingSlots;
  final String? slotsError;
  final AvailableSlot? selectedSlot;
  final List<StaffMember> availableBarbers;
  final bool isLoadingBarbers;
  final String? barbersError;
  final StaffMember? selectedBarber;

  final bool isSubmitting;
  final String? apiError;

  bool get canProceed =>
      selectedServiceIds.isNotEmpty || selectedPackageIds.isNotEmpty;
  bool get hasItems => services.isNotEmpty || packages.isNotEmpty;

  bool get canProceedToPayment =>
      selectedDate != null && selectedSlot != null && selectedBarber != null;

  List<CouponEligibleService> get selectedServices =>
      services.where((s) => selectedServiceIds.contains(s.id)).toList();

  List<CouponEligiblePackage> get selectedPackages =>
      packages.where((p) => selectedPackageIds.contains(p.id)).toList();

  List<int> get selectedServiceIdsList => selectedServiceIds.toList();
  List<int> get selectedPackageIdsList => selectedPackageIds.toList();

  ClaimCouponData copyWith({
    int? step,
    Set<int>? selectedServiceIds,
    Set<int>? selectedPackageIds,
    DateTime? selectedDate,
    List<AvailableSlot>? availableSlots,
    bool? isLoadingSlots,
    String? Function()? slotsError,
    AvailableSlot? Function()? selectedSlot,
    List<StaffMember>? availableBarbers,
    bool? isLoadingBarbers,
    String? Function()? barbersError,
    StaffMember? Function()? selectedBarber,
    bool? isSubmitting,
    String? Function()? apiError,
  }) {
    return ClaimCouponData(
      couponId: couponId,
      salonId: salonId,
      couponCode: couponCode,
      couponName: couponName,
      salonName: salonName,
      step: step ?? this.step,
      services: services,
      packages: packages,
      selectedServiceIds: selectedServiceIds ?? this.selectedServiceIds,
      selectedPackageIds: selectedPackageIds ?? this.selectedPackageIds,
      selectedDate: selectedDate ?? this.selectedDate,
      availableSlots: availableSlots ?? this.availableSlots,
      isLoadingSlots: isLoadingSlots ?? this.isLoadingSlots,
      slotsError: slotsError != null ? slotsError() : this.slotsError,
      selectedSlot: selectedSlot != null ? selectedSlot() : this.selectedSlot,
      availableBarbers: availableBarbers ?? this.availableBarbers,
      isLoadingBarbers: isLoadingBarbers ?? this.isLoadingBarbers,
      barbersError: barbersError != null ? barbersError() : this.barbersError,
      selectedBarber:
          selectedBarber != null ? selectedBarber() : this.selectedBarber,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      apiError: apiError != null ? apiError() : this.apiError,
    );
  }
}

class ClaimCouponSuccess extends ClaimCouponState {
  const ClaimCouponSuccess({required this.appointment});

  final CreatedAppointment appointment;
}
