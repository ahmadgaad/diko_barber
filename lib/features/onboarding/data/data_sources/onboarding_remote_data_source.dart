import 'package:zain/core/networking/api_consumer.dart';
import 'package:zain/core/networking/api_response.dart';
import 'package:zain/core/networking/endpoints.dart';

abstract class OnboardingRemoteDataSource {
  Future<ApiResponse<dynamic>> getItems();
}

class OnboardingRemoteDataSourceImpl implements OnboardingRemoteDataSource {
  const OnboardingRemoteDataSourceImpl(this._networkService);

  final INetworkService _networkService;

  @override
  Future<ApiResponse<dynamic>> getItems() =>
      _networkService.getData(endPoint: EndPoints.onboarding);
}
