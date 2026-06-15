import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import '../../domain/entities/coupon_eligible_items.dart';
import '../../domain/repositories/claim_coupon_repository.dart';
import '../data_sources/claim_coupon_remote_data_source.dart';
import '../models/coupon_eligible_package_model.dart';
import '../models/coupon_eligible_service_model.dart';

class ClaimCouponRepositoryImpl implements ClaimCouponRepository {
  const ClaimCouponRepositoryImpl(this._dataSource);

  final ClaimCouponRemoteDataSource _dataSource;

  @override
  Future<Result<ApiErrorModel, CouponEligibleItems>> getEligibleItems(
    int couponId,
  ) async {
    try {
      final response = await _dataSource.getEligibleItems(couponId);
      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }
      final data = response.data as Map<String, dynamic>;
      final services = (data['services'] as List)
          .whereType<Map<String, dynamic>>()
          .map(CouponEligibleServiceModel.fromJson)
          .toList();
      final packages = (data['packages'] as List)
          .whereType<Map<String, dynamic>>()
          .map(CouponEligiblePackageModel.fromJson)
          .toList();
      return Success(CouponEligibleItems(services: services, packages: packages));
    } catch (_) {
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }
}
