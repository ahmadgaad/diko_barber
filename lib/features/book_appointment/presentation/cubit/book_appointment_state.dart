import 'package:ronaq_barber/features/book_appointment/domain/entities/appointment_service.dart';
import 'package:ronaq_barber/features/book_appointment/domain/entities/coupon_validation.dart';
import 'package:ronaq_barber/features/book_appointment/domain/entities/staff_member.dart';
import 'package:ronaq_barber/features/book_appointment/domain/entities/time_slot.dart';

sealed class BookAppointmentState {
  const BookAppointmentState();
}

class BookAppointmentLoading extends BookAppointmentState {
  const BookAppointmentLoading();
}

class BookAppointmentError extends BookAppointmentState {
  const BookAppointmentError({required this.message});

  final String message;
}

class BookAppointmentData extends BookAppointmentState {
  const BookAppointmentData({
    required this.salonId,
    required this.salonName,
    required this.step,
    required this.services,
    required this.staff,
    required this.selectedDate,
    required this.slots,
    this.selectedService,
    this.selectedStaff,
    this.staffSelected = false,
    this.selectedSlot,
    this.couponCode,
    this.couponValidation,
    this.isLoadingStaff = false,
    this.isLoadingSlots = false,
    this.isValidatingCoupon = false,
    this.isSubmitting = false,
    this.apiError,
  });

  final int salonId;
  final String salonName;
  final int step;
  final List<AppointmentService> services;
  final AppointmentService? selectedService;
  final List<StaffMember> staff;
  final StaffMember? selectedStaff;
  final bool staffSelected;
  final DateTime selectedDate;
  final List<TimeSlot> slots;
  final TimeSlot? selectedSlot;
  final String? couponCode;
  final CouponValidation? couponValidation;
  final bool isLoadingStaff;
  final bool isLoadingSlots;
  final bool isValidatingCoupon;
  final bool isSubmitting;
  final String? apiError;

  bool get canProceedStep1 => selectedService != null;
  bool get canProceedStep2 => staffSelected;
  bool get canProceedStep3 => selectedSlot != null;

  num get originalPrice => selectedService?.price ?? 0;

  num get discountAmount {
    if (couponValidation == null || !couponValidation!.isValid) return 0;
    if (couponValidation!.discountType == 'percentage') {
      return originalPrice * couponValidation!.discountAmount / 100;
    }
    return couponValidation!.discountAmount;
  }

  num get finalPrice =>
      (originalPrice - discountAmount).clamp(0, double.infinity);

  BookAppointmentData copyWith({
    int? salonId,
    String? salonName,
    int? step,
    List<AppointmentService>? services,
    AppointmentService? Function()? selectedService,
    List<StaffMember>? staff,
    StaffMember? Function()? selectedStaff,
    bool? staffSelected,
    DateTime? selectedDate,
    List<TimeSlot>? slots,
    TimeSlot? Function()? selectedSlot,
    String? Function()? couponCode,
    CouponValidation? Function()? couponValidation,
    bool? isLoadingStaff,
    bool? isLoadingSlots,
    bool? isValidatingCoupon,
    bool? isSubmitting,
    String? Function()? apiError,
  }) {
    return BookAppointmentData(
      salonId: salonId ?? this.salonId,
      salonName: salonName ?? this.salonName,
      step: step ?? this.step,
      services: services ?? this.services,
      selectedService:
          selectedService != null ? selectedService() : this.selectedService,
      staff: staff ?? this.staff,
      selectedStaff:
          selectedStaff != null ? selectedStaff() : this.selectedStaff,
      staffSelected: staffSelected ?? this.staffSelected,
      selectedDate: selectedDate ?? this.selectedDate,
      slots: slots ?? this.slots,
      selectedSlot: selectedSlot != null ? selectedSlot() : this.selectedSlot,
      couponCode: couponCode != null ? couponCode() : this.couponCode,
      couponValidation: couponValidation != null
          ? couponValidation()
          : this.couponValidation,
      isLoadingStaff: isLoadingStaff ?? this.isLoadingStaff,
      isLoadingSlots: isLoadingSlots ?? this.isLoadingSlots,
      isValidatingCoupon: isValidatingCoupon ?? this.isValidatingCoupon,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      apiError: apiError != null ? apiError() : this.apiError,
    );
  }
}

class BookAppointmentSuccess extends BookAppointmentState {
  const BookAppointmentSuccess({required this.bookingId});

  final int bookingId;
}
