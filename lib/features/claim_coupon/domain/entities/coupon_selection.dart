import 'coupon_eligible_package.dart';
import 'coupon_eligible_service.dart';

sealed class CouponSelection {
  const CouponSelection();
}

class ServiceCouponSelection extends CouponSelection {
  const ServiceCouponSelection(this.service);
  final CouponEligibleService service;
}

class PackageCouponSelection extends CouponSelection {
  const PackageCouponSelection(this.package);
  final CouponEligiblePackage package;
}
