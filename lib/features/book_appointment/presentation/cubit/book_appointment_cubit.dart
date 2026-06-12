// ignore_for_file: unused_field
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/features/book_appointment/domain/entities/appointment_service.dart';
import 'package:ronaq_barber/features/book_appointment/domain/entities/coupon_validation.dart';
import 'package:ronaq_barber/features/book_appointment/domain/entities/staff_member.dart';
import 'package:ronaq_barber/features/book_appointment/domain/entities/time_slot.dart';
import 'package:ronaq_barber/features/book_appointment/domain/use_cases/create_booking_use_case.dart';
import 'package:ronaq_barber/features/book_appointment/domain/use_cases/get_salon_services_use_case.dart';
import 'package:ronaq_barber/features/book_appointment/domain/use_cases/get_staff_use_case.dart';
import 'package:ronaq_barber/features/book_appointment/domain/use_cases/get_time_slots_use_case.dart';
import 'package:ronaq_barber/features/book_appointment/domain/use_cases/validate_coupon_use_case.dart';
import 'package:ronaq_barber/features/book_appointment/presentation/cubit/book_appointment_state.dart';

class BookAppointmentCubit extends Cubit<BookAppointmentState> {
  BookAppointmentCubit({
    required GetSalonServicesUseCase getSalonServicesUseCase,
    required GetStaffUseCase getStaffUseCase,
    required GetTimeSlotsUseCase getTimeSlotsUseCase,
    required ValidateCouponUseCase validateCouponUseCase,
    required CreateBookingUseCase createBookingUseCase,
  })  : _getSalonServices = getSalonServicesUseCase,
        _getStaff = getStaffUseCase,
        _getTimeSlots = getTimeSlotsUseCase,
        _validateCoupon = validateCouponUseCase,
        _createBooking = createBookingUseCase,
        super(const BookAppointmentLoading());

  final GetSalonServicesUseCase _getSalonServices;
  final GetStaffUseCase _getStaff;
  final GetTimeSlotsUseCase _getTimeSlots;
  final ValidateCouponUseCase _validateCoupon;
  final CreateBookingUseCase _createBooking;

  Future<void> load(
    int salonId,
    String salonName, {
    String? couponCode,
  }) async {
    emit(const BookAppointmentLoading());
    await Future.delayed(const Duration(milliseconds: 600));
    if (isClosed) return;
    emit(BookAppointmentData(
      salonId: salonId,
      salonName: salonName,
      step: 1,
      services: _mockServices(),
      staff: [],
      selectedDate: DateTime.now(),
      slots: [],
      couponCode: couponCode,
    ));
  }

  void selectService(AppointmentService service) async {
    final current = state;
    if (current is! BookAppointmentData) return;

    emit(current.copyWith(
      selectedService: () => service,
      isLoadingStaff: true,
    ));

    if (current.couponCode != null) {
      _triggerCouponValidation(current.couponCode!, service.id);
    }

    await Future.delayed(const Duration(milliseconds: 400));
    if (isClosed) return;
    final updated = state;
    if (updated is! BookAppointmentData) return;
    emit(updated.copyWith(staff: _mockStaff(), isLoadingStaff: false));
  }

  void selectStaff(StaffMember? staff) {
    final current = state;
    if (current is! BookAppointmentData) return;
    emit(current.copyWith(
      selectedStaff: () => staff,
      staffSelected: true,
    ));
  }

  void selectDate(DateTime date) async {
    final current = state;
    if (current is! BookAppointmentData) return;
    emit(current.copyWith(
      selectedDate: date,
      selectedSlot: () => null,
      isLoadingSlots: true,
    ));
    await Future.delayed(const Duration(milliseconds: 350));
    if (isClosed) return;
    final updated = state;
    if (updated is! BookAppointmentData) return;
    emit(updated.copyWith(slots: _mockSlots(), isLoadingSlots: false));
  }

  void selectSlot(TimeSlot slot) {
    final current = state;
    if (current is! BookAppointmentData) return;
    emit(current.copyWith(selectedSlot: () => slot));
  }

  void goToStep(int step) {
    final current = state;
    if (current is! BookAppointmentData) return;
    if (step == 3 && current.slots.isEmpty) {
      _loadInitialSlots(current);
      return;
    }
    emit(current.copyWith(step: step, apiError: () => null));
  }

  Future<void> _loadInitialSlots(BookAppointmentData current) async {
    emit(current.copyWith(step: 3, isLoadingSlots: true, apiError: () => null));
    await Future.delayed(const Duration(milliseconds: 350));
    if (isClosed) return;
    final updated = state;
    if (updated is! BookAppointmentData) return;
    emit(updated.copyWith(slots: _mockSlots(), isLoadingSlots: false));
  }

  Future<void> _triggerCouponValidation(String code, int serviceId) async {
    final current = state;
    if (current is! BookAppointmentData) return;
    emit(current.copyWith(isValidatingCoupon: true));
    await Future.delayed(const Duration(milliseconds: 500));
    if (isClosed) return;
    final updated = state;
    if (updated is! BookAppointmentData) return;
    emit(updated.copyWith(
      isValidatingCoupon: false,
      couponValidation: () => const CouponValidation(
        isValid: true,
        discountAmount: 30,
        discountType: 'percentage',
      ),
    ));
  }

  Future<void> confirmBooking() async {
    final current = state;
    if (current is! BookAppointmentData) return;
    if (current.selectedService == null || current.selectedSlot == null) return;

    emit(current.copyWith(isSubmitting: true, apiError: () => null));
    await Future.delayed(const Duration(milliseconds: 800));
    if (isClosed) return;

    emit(const BookAppointmentSuccess(bookingId: 1001));
  }

  List<AppointmentService> _mockServices() => [
        const AppointmentService(
          id: 1,
          name: 'قص الشعر الكلاسيكي',
          description: 'قصة شعر احترافية بالمقص وماكينة القص',
          image: 'https://picsum.photos/seed/svc1/200/200',
          price: 120,
          durationMinutes: 30,
          rating: 4.9,
        ),
        const AppointmentService(
          id: 2,
          name: 'تشذيب وتشكيل اللحية',
          description: 'تشذيب وتشكيل اللحية مع الموس الاحترافي',
          image: 'https://picsum.photos/seed/svc2/200/200',
          price: 80,
          durationMinutes: 20,
          rating: 4.8,
        ),
        const AppointmentService(
          id: 3,
          name: 'قص الشعر + تشذيب اللحية',
          description: 'الباقة الأساسية شاملة قصة الشعر وتشذيب اللحية',
          image: 'https://picsum.photos/seed/svc3/200/200',
          price: 180,
          durationMinutes: 50,
          rating: 4.9,
        ),
        const AppointmentService(
          id: 4,
          name: 'تنظيف البشرة العميق',
          description: 'تنظيف وترطيب البشرة بأفضل المنتجات العناية',
          image: 'https://picsum.photos/seed/svc4/200/200',
          price: 200,
          durationMinutes: 45,
          rating: 4.7,
        ),
        const AppointmentService(
          id: 5,
          name: 'تصفيف الشعر',
          description: 'تصفيف وتشكيل الشعر بالكريمات الفاخرة',
          image: 'https://picsum.photos/seed/svc5/200/200',
          price: 100,
          durationMinutes: 25,
          rating: 4.6,
        ),
      ];

  List<StaffMember> _mockStaff() => [
        const StaffMember(
          id: 1,
          name: 'محمد السيد',
          avatar: 'https://picsum.photos/seed/staff1/80/80',
          specialization: 'قص الشعر والتصفيف',
        ),
        const StaffMember(
          id: 2,
          name: 'أحمد حسن',
          avatar: 'https://picsum.photos/seed/staff2/80/80',
          specialization: 'تشذيب اللحية والعناية',
        ),
        const StaffMember(
          id: 3,
          name: 'عمر خالد',
          avatar: 'https://picsum.photos/seed/staff3/80/80',
          specialization: 'العناية بالبشرة والعلاج',
        ),
        const StaffMember(
          id: 4,
          name: 'كريم إبراهيم',
          avatar: 'https://picsum.photos/seed/staff4/80/80',
          specialization: 'قص الشعر الكلاسيكي',
        ),
      ];

  List<TimeSlot> _mockSlots() => [
        const TimeSlot(id: 1, time: '09:00', isAvailable: true),
        const TimeSlot(id: 2, time: '09:30', isAvailable: true),
        const TimeSlot(id: 3, time: '10:00', isAvailable: false),
        const TimeSlot(id: 4, time: '10:30', isAvailable: true),
        const TimeSlot(id: 5, time: '11:00', isAvailable: true),
        const TimeSlot(id: 6, time: '11:30', isAvailable: false),
        const TimeSlot(id: 7, time: '12:00', isAvailable: true),
        const TimeSlot(id: 8, time: '17:00', isAvailable: true),
      ];
}
