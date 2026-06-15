import 'coupon_eligible_package.dart';
import 'coupon_eligible_service.dart';

class CouponEligibleItems {
  const CouponEligibleItems({
    required this.services,
    required this.packages,
  });

  final List<CouponEligibleService> services;
  final List<CouponEligiblePackage> packages;

  bool get isEmpty => services.isEmpty && packages.isEmpty;
}
