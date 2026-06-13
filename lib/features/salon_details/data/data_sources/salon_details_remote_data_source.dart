import 'package:ronaq_barber/core/networking/api_consumer.dart';
import 'package:ronaq_barber/core/networking/api_response.dart';
import 'package:ronaq_barber/core/networking/endpoints.dart';

abstract class SalonDetailsRemoteDataSource {
  Future<ApiResponse<dynamic>> getSalonDetails(
    int id,
    Map<String, dynamic> queryParams,
  );

  Future<ApiResponse<dynamic>> getSalonGallery(
    int id,
    Map<String, dynamic> queryParams,
  );

  Future<ApiResponse<dynamic>> getSalonRatings(
    int id,
    Map<String, dynamic> queryParams,
  );
}

class SalonDetailsRemoteDataSourceImpl implements SalonDetailsRemoteDataSource {
  const SalonDetailsRemoteDataSourceImpl(this._networkService);

  final INetworkService _networkService;

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
  Future<ApiResponse<dynamic>> getSalonGallery(
    int id,
    Map<String, dynamic> queryParams,
  ) =>
      _networkService.getData(
        endPoint: EndPoints.salonGallery(id),
        queryParameters: queryParams,
      );

  @override
  Future<ApiResponse<dynamic>> getSalonRatings(
    int id,
    Map<String, dynamic> queryParams,
  ) =>
      _networkService.getData(
        endPoint: EndPoints.salonRatings(id),
        queryParameters: queryParams,
      );
}
