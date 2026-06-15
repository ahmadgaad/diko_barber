import 'package:zain/core/networking/api_consumer.dart';
import 'package:zain/core/networking/api_response.dart';
import 'package:zain/core/networking/endpoints.dart';

abstract class ClaimCouponRemoteDataSource {
  Future<ApiResponse<dynamic>> getEligibleItems(int couponId);
}

class ClaimCouponRemoteDataSourceImpl implements ClaimCouponRemoteDataSource {
  const ClaimCouponRemoteDataSourceImpl(this._networkService);

  final INetworkService _networkService;

  @override
  Future<ApiResponse<dynamic>> getEligibleItems(int couponId) =>
      _networkService.getData(
        endPoint: EndPoints.couponServicesAndPackages,
        queryParameters: {'coupon_id': couponId},
      );
}
