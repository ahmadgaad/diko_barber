import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import '../entities/coupon_eligible_items.dart';
import '../repositories/claim_coupon_repository.dart';

class GetCouponEligibleItemsUseCase {
  const GetCouponEligibleItemsUseCase(this._repository);

  final ClaimCouponRepository _repository;

  Future<Result<ApiErrorModel, CouponEligibleItems>> call(int couponId) =>
      _repository.getEligibleItems(couponId);
}
