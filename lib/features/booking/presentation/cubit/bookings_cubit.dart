import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/shared/domain/entities/booking.dart';
import 'package:zain/features/booking/presentation/cubit/bookings_state.dart';

class BookingsCubit extends Cubit<BookingsState> {
  BookingsCubit() : super(const BookingsLoading()) {
    _load();
  }

  void _load() {
    Future.delayed(const Duration(milliseconds: 700), () {
      if (isClosed) return;
      final bookings = _mockBookings();
      emit(BookingsLoaded(all: bookings, filtered: bookings));
    });
  }

  void filterByStatus(BookingStatus? status) {
    final current = state;
    if (current is! BookingsLoaded) return;
    final filtered = status == null
        ? current.all
        : current.all.where((b) => b.status == status).toList();
    emit(current.copyWith(
      filtered: filtered,
      selectedStatus: () => status,
    ));
  }

  List<Booking> _mockBookings() => [
        Booking(
          id: 1,
          salonName: 'صالون القص الملكي',
          salonLogo: 'https://picsum.photos/seed/salon1/80/80',
          serviceName: 'قص الشعر الكلاسيكي',
          price: 120,
          dateTime: DateTime(2026, 6, 15, 11, 0),
          status: BookingStatus.confirmed,
          staffName: 'أحمد الحلاق',
          address: 'شارع التحرير، وسط البلد',
        ),
        Booking(
          id: 2,
          salonName: 'صالون البرستيج',
          salonLogo: 'https://picsum.photos/seed/salon2/80/80',
          serviceName: 'الباقة الكاملة',
          price: 320,
          dateTime: DateTime(2026, 6, 18, 14, 30),
          status: BookingStatus.pending,
          staffName: 'محمد الخبير',
          address: 'مدينة نصر، شارع عباس العقاد',
        ),
        Booking(
          id: 3,
          salonName: 'ركن الرجل الأنيق',
          salonLogo: 'https://picsum.photos/seed/salon3/80/80',
          serviceName: 'تشذيب وتشكيل اللحية',
          price: 80,
          dateTime: DateTime(2026, 6, 5, 10, 0),
          status: BookingStatus.completed,
          staffName: 'خالد الأستاذ',
          address: 'المعادي، شارع النصر',
        ),
        Booking(
          id: 4,
          salonName: 'العناية العصرية',
          salonLogo: 'https://picsum.photos/seed/salon4/80/80',
          serviceName: 'تنظيف البشرة العميق',
          price: 200,
          dateTime: DateTime(2026, 5, 28, 16, 0),
          status: BookingStatus.cancelled,
          staffName: null,
          address: 'الزمالك، شارع حسن صبري',
        ),
        Booking(
          id: 5,
          salonName: 'صالون القص الملكي',
          salonLogo: 'https://picsum.photos/seed/salon1/80/80',
          serviceName: 'تجربة VIP',
          price: 500,
          dateTime: DateTime(2026, 5, 20, 12, 0),
          status: BookingStatus.completed,
          staffName: 'أحمد الحلاق',
          address: 'شارع التحرير، وسط البلد',
        ),
        Booking(
          id: 6,
          salonName: 'صالون البرستيج',
          salonLogo: 'https://picsum.photos/seed/salon2/80/80',
          serviceName: 'باقة العريس',
          price: 750,
          dateTime: DateTime(2026, 6, 25, 9, 0),
          status: BookingStatus.confirmed,
          staffName: 'محمد الخبير',
          address: 'مدينة نصر، شارع عباس العقاد',
        ),
      ];
}
