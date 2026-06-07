import 'package:ronaq_barber/core/networking/api_consumer.dart';
import 'package:ronaq_barber/core/networking/api_response.dart';
import 'package:ronaq_barber/core/networking/endpoints.dart';

abstract class SharedRemoteDataSource {
  Future<ApiResponse<dynamic>> getCities();
  Future<ApiResponse<dynamic>> getNeighborhoods({required int cityId});
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
}
