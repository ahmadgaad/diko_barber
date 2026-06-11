import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/shared/domain/entities/coupon.dart';

import 'coupons_state.dart';

class CouponsCubit extends Cubit<CouponsState> {
  CouponsCubit() : super(const CouponsLoading()) {
    _loadMock();
  }

  Future<void> _loadMock() async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (isClosed) return;
    final now = DateTime.now();
    emit(CouponsLoaded([
      Coupon(
        id: 1,
        code: 'SAVE20',
        discountPercent: 20,
        serviceLabel: 'خدمة قص الشعر',
        salonName: 'صالون القص الملكي',
        salonLogo: '',
        expiresAt: now.add(const Duration(days: 2, hours: 14)),
      ),
      Coupon(
        id: 2,
        code: 'BEARD15',
        discountPercent: 15,
        serviceLabel: 'تشذيب اللحية',
        salonName: 'صالون البرستيج',
        salonLogo: '',
        expiresAt: now.add(const Duration(hours: 5, minutes: 30)),
      ),
      Coupon(
        id: 3,
        code: 'VIP30',
        discountPercent: 30,
        serviceLabel: 'باقة كبار الشخصيات',
        salonName: 'ركن الرجل الأنيق',
        salonLogo: '',
        expiresAt: now.add(const Duration(days: 5)),
      ),
    ]));
  }
}
