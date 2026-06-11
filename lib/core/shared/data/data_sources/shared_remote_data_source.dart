import 'package:ronaq_barber/core/networking/api_consumer.dart';
import 'package:ronaq_barber/core/networking/api_response.dart';
import 'package:ronaq_barber/core/networking/endpoints.dart';

abstract class SharedRemoteDataSource {
  Future<ApiResponse<dynamic>> getCities();
  Future<ApiResponse<dynamic>> getNeighborhoods({required int cityId});
  Future<ApiResponse<dynamic>> getCategories({int? specialization});
  Future<ApiResponse<dynamic>> getBanners();
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
}
