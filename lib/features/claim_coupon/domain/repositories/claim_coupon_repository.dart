import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import '../entities/coupon_eligible_items.dart';

abstract interface class ClaimCouponRepository {
  Future<Result<ApiErrorModel, CouponEligibleItems>> getEligibleItems(
    int couponId,
  );
}
