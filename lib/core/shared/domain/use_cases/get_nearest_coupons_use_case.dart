import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/core/shared/domain/entities/coupon.dart';
import 'package:ronaq_barber/core/shared/domain/entities/nearest_coupons_params.dart';
import 'package:ronaq_barber/core/shared/domain/repositories/shared_repository.dart';

class GetNearestCouponsUseCase {
  const GetNearestCouponsUseCase(this._repository);

  final SharedRepository _repository;

  Future<Result<ApiErrorModel, List<Coupon>>> call(
    NearestCouponsParams params,
  ) =>
      _repository.getNearestCoupons(params);
}
