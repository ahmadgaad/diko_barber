import 'package:ronaq_barber/core/networking/api_consumer.dart';
import 'package:ronaq_barber/core/networking/api_response.dart';
import 'package:ronaq_barber/core/networking/endpoints.dart';

abstract class SharedRemoteDataSource {
  Future<ApiResponse<dynamic>> getCities();
  Future<ApiResponse<dynamic>> getNeighborhoods({required int cityId});
  Future<ApiResponse<dynamic>> getCategories({int? specialization});
  Future<ApiResponse<dynamic>> getBanners();
  Future<ApiResponse<dynamic>> getNearestSalons(
    Map<String, dynamic> queryParams,
  );
  Future<ApiResponse<dynamic>> getNearestCoupons(
    Map<String, dynamic> queryParams,
  );
  Future<ApiResponse<dynamic>> getNearestPackages(
    Map<String, dynamic> queryParams,
  );
  Future<ApiResponse<dynamic>> getNearestServices(
    Map<String, dynamic> queryParams,
  );
  Future<ApiResponse<dynamic>> getPackageDetails(int id);
  Future<ApiResponse<dynamic>> getSalonDetails(
    int id,
    Map<String, dynamic> queryParams,
  );
  Future<ApiResponse<dynamic>> toggleFavorite({
    required int id,
    required int type,
  });
  Future<ApiResponse<dynamic>> getFavorites(int type);
}

class SharedRemoteDataSourceImpl implements SharedRemoteDataSource {
  const SharedRemoteDataSourceImpl(this._networkService);

  final INetworkService _networkService;

  @override
  Future<ApiResponse<dynamic>> getCities() =>
      _networkService.getData(endPoint: EndPoints.cities);

  @override
  Future<ApiResponse<dynamic>> getNeighborhoods({required int cityId}) =>
      _networkService.getData(
        endPoint: EndPoints.neighborhoods,
        queryParameters: {'city_id': cityId},
      );

  @override
  Future<ApiResponse<dynamic>> getCategories({int? specialization}) =>
      _networkService.getData(
        endPoint: EndPoints.categories,
        queryParameters: specialization != null
            ? {'specialization': specialization}
            : null,
      );

  @override
  Future<ApiResponse<dynamic>> getBanners() =>
      _networkService.getData(endPoint: EndPoints.banners);

  @override
  Future<ApiResponse<dynamic>> getNearestSalons(
    Map<String, dynamic> queryParams,
  ) =>
      _networkService.getData(
        endPoint: EndPoints.nearestSalons,
        queryParameters: queryParams,
      );

  @override
  Future<ApiResponse<dynamic>> getNearestCoupons(
    Map<String, dynamic> queryParams,
  ) =>
      _networkService.getData(
        endPoint: EndPoints.nearestCoupons,
        queryParameters: queryParams,
      );

  @override
  Future<ApiResponse<dynamic>> getNearestPackages(
    Map<String, dynamic> queryParams,
  ) =>
      _networkService.getData(
        endPoint: EndPoints.nearestPackages,
        queryParameters: queryParams,
      );

  @override
  Future<ApiResponse<dynamic>> getNearestServices(
    Map<String, dynamic> queryParams,
  ) =>
      _networkService.getData(
        endPoint: EndPoints.nearestServices,
        queryParameters: queryParams,
      );

  @override
  Future<ApiResponse<dynamic>> getPackageDetails(int id) =>
      _networkService.getData(endPoint: EndPoints.packageDetails(id));

  @override
  Future<ApiResponse<dynamic>> getSalonDetails(
    int id,
    Map<String, dynamic> queryParams,
  ) =>
      _networkService.getData(
        endPoint: EndPoints.salonDetails(id),
        queryParameters: queryParams,
      );

  @override
  Future<ApiResponse<dynamic>> getFavorites(int type) =>
      _networkService.getData(
        endPoint: EndPoints.favorites,
        queryParameters: {'type': type},
      );

  @override
  Future<ApiResponse<dynamic>> toggleFavorite({
    required int id,
    required int type,
  }) =>
      _networkService.postData(
        endPoint: EndPoints.toggleFavorite,
        body: {'id': id, 'type': type},
      );
}
