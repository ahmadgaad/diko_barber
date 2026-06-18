import 'package:zain/core/networking/api_consumer.dart';
import 'package:zain/core/networking/api_response.dart';
import 'package:zain/core/networking/endpoints.dart';

abstract class ClaimCouponRemoteDataSource {
  Future<ApiResponse<dynamic>> getEligibleItems(int couponId);

  Future<ApiResponse<dynamic>> getAvailableSlots({
    required int salonId,
    required String date,
    required List<int> serviceIds,
    required List<int> packageIds,
    int? staffId,
  });

  Future<ApiResponse<dynamic>> getAvailableBarbers({
    required int salonId,
    required String date,
    required String startTime,
    required List<int> serviceIds,
    required List<int> packageIds,
  });
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

  @override
  Future<ApiResponse<dynamic>> getAvailableSlots({
    required int salonId,
    required String date,
    required List<int> serviceIds,
    required List<int> packageIds,
    int? staffId,
  }) {
    final params = <String, dynamic>{
      'date': date,
      if (serviceIds.isNotEmpty) 'service_ids[]': serviceIds,
      if (packageIds.isNotEmpty) 'package_ids[]': packageIds,
      'staff_id': ?staffId,
    };
    return _networkService.getData(
      endPoint: EndPoints.availableSlots(salonId),
      queryParameters: params,
    );
  }

  @override
  Future<ApiResponse<dynamic>> getAvailableBarbers({
    required int salonId,
    required String date,
    required String startTime,
    required List<int> serviceIds,
    required List<int> packageIds,
  }) {
    final params = <String, dynamic>{
      'date': date,
      'start_time': startTime,
      if (serviceIds.isNotEmpty) 'service_ids[]': serviceIds,
      if (packageIds.isNotEmpty) 'package_ids[]': packageIds,
    };
    return _networkService.getData(
      endPoint: EndPoints.availableBarbers(salonId),
      queryParameters: params,
    );
  }
}
