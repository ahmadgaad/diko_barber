import 'package:ronaq_barber/core/networking/api_consumer.dart';
import 'package:ronaq_barber/core/networking/api_response.dart';
import 'package:ronaq_barber/core/networking/endpoints.dart';
import 'package:ronaq_barber/core/shared/domain/entities/nearest_packages_params.dart';

abstract class PackagesRemoteDataSource {
  Future<ApiResponse<dynamic>> getPackages(NearestPackagesParams params);
  Future<ApiResponse<dynamic>> getPackageDetails(int id);
}

class PackagesRemoteDataSourceImpl implements PackagesRemoteDataSource {
  const PackagesRemoteDataSourceImpl(this._networkService);

  final INetworkService _networkService;

  @override
  Future<ApiResponse<dynamic>> getPackages(NearestPackagesParams params) =>
      _networkService.getData(
        endPoint: EndPoints.nearestPackages,
        queryParameters: _buildQuery(params),
      );

  @override
  Future<ApiResponse<dynamic>> getPackageDetails(int id) =>
      _networkService.getData(endPoint: EndPoints.packageDetails(id));

  Map<String, dynamic> _buildQuery(NearestPackagesParams params) {
    final query = <String, dynamic>{
      'page': params.page.toString(),
      'per_page': params.perPage.toString(),
      'is_home': params.isHome ? '1' : '0',
    };
    if (params.lat != null) query['lat'] = params.lat.toString();
    if (params.long != null) query['long'] = params.long.toString();
    if (params.search != null && params.search!.isNotEmpty) {
      query['search'] = params.search;
    }
    for (final id in params.categoryIds) {
      query['category_ids[]'] = id.toString();
    }
    for (final s in params.sortBy) {
      query['sort_by[]'] = s;
    }
    return query;
  }
}
