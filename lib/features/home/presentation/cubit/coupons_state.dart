import 'package:ronaq_barber/core/shared/domain/entities/coupon.dart';

sealed class CouponsState {
  const CouponsState();
}

class CouponsLoading extends CouponsState {
  const CouponsLoading();
}

class CouponsLoaded extends CouponsState {
  const CouponsLoaded(this.coupons);
  final List<Coupon> coupons;
}

class CouponsError extends CouponsState {
  const CouponsError();
}
