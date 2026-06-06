import 'package:ronaq_barber/core/networking/api_consumer.dart';
import 'package:ronaq_barber/core/networking/api_response.dart';
import 'package:ronaq_barber/core/networking/endpoints.dart';

abstract class AuthRemoteDataSource {
  Future<ApiResponse<dynamic>> signIn({
    required String login,
    required String password,
    String? fcmToken,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._networkService);

  final INetworkService _networkService;

  @override
  Future<ApiResponse<dynamic>> signIn({
    required String login,
    required String password,
    String? fcmToken,
  }) {
    return _networkService.postData(
      endPoint: EndPoints.login,
      body: {'login': login, 'password': password, 'fcm_token': ?fcmToken},
    );
  }
}
