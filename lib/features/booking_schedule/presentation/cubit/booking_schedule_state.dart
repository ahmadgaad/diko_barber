import 'package:zain/features/book_appointment/domain/entities/staff_member.dart';
import 'package:zain/features/booking_schedule/domain/entities/created_appointment.dart';
import 'package:zain/features/claim_coupon/domain/entities/available_slot.dart';

sealed class BookingScheduleState {
  const BookingScheduleState();
}

class BookingScheduleForm extends BookingScheduleState {
  const BookingScheduleForm({
    required this.salonId,
    required this.salonName,
    required this.serviceIds,
    required this.packageIds,
    this.couponCode,
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

  final int salonId;
  final String salonName;
  final List<int> serviceIds;
  final List<int> packageIds;
  final String? couponCode;

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

  bool get canConfirm =>
      selectedDate != null && selectedSlot != null && selectedBarber != null;

  BookingScheduleForm copyWith({
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
    return BookingScheduleForm(
      salonId: salonId,
      salonName: salonName,
      serviceIds: serviceIds,
      packageIds: packageIds,
      couponCode: couponCode,
      selectedDate: selectedDate ?? this.selectedDate,
      availableSlots: availableSlots ?? this.availableSlots,
      isLoadingSlots: isLoadingSlots ?? this.isLoadingSlots,
      slotsError: slotsError != null ? slotsError() : this.slotsError,
      selectedSlot:
          selectedSlot != null ? selectedSlot() : this.selectedSlot,
      availableBarbers: availableBarbers ?? this.availableBarbers,
      isLoadingBarbers: isLoadingBarbers ?? this.isLoadingBarbers,
      barbersError:
          barbersError != null ? barbersError() : this.barbersError,
      selectedBarber:
          selectedBarber != null ? selectedBarber() : this.selectedBarber,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      apiError: apiError != null ? apiError() : this.apiError,
    );
  }
}

class BookingScheduleSuccess extends BookingScheduleState {
  const BookingScheduleSuccess({required this.appointment});
  final CreatedAppointment appointment;
}
