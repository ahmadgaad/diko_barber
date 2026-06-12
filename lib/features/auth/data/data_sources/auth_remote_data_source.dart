import 'package:dio/dio.dart';
import 'package:ronaq_barber/core/networking/api_consumer.dart';
import 'package:ronaq_barber/core/networking/api_response.dart';
import 'package:ronaq_barber/core/networking/endpoints.dart';
import 'package:ronaq_barber/features/auth/domain/entities/sign_up_params.dart';

abstract class AuthRemoteDataSource {
  Future<ApiResponse<dynamic>> signIn({
    required String login,
    required String password,
    String? fcmToken,
  });

  Future<ApiResponse<dynamic>> signUp(SignUpParams params);

  Future<ApiResponse<dynamic>> verifyOtp({
    required String key,
    required String otp,
  });

  Future<ApiResponse<dynamic>> resendVerification({required String key});

  Future<ApiResponse<dynamic>> socialLogin({
    required String provider,
    required String accessToken,
    String? idToken,
    String? fcmToken,
  });

  Future<ApiResponse<dynamic>> forgotPassword({required String key});

  Future<ApiResponse<dynamic>> verifyResetPassword({
    required String key,
    required String otp,
  });

  Future<ApiResponse<dynamic>> resetPassword({
    required String password,
    required String passwordConfirmation,
  });

  Future<ApiResponse<dynamic>> logout();
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

  @override
  Future<ApiResponse<dynamic>> signUp(SignUpParams params) async {
    final body = <String, dynamic>{
      'name': params.name,
      'password': params.password,
      'password_confirmation': params.passwordConfirmation,
      'phone': ?params.phone,
      'email': ?params.email,
      'city_id': ?params.cityId,
      'neighborhood_id': ?params.neighborhoodId,
      'gender': ?params.gender,
      'age': ?params.age,
      'fcm_token': ?params.fcmToken,
      'verify_with': 2,
      'lat': ?params.lat?.toString(),
      'long': ?params.lng?.toString(),
      'location': ?params.location,
    };

    if (params.imagePath != null) {
      body['image'] = await MultipartFile.fromFile(params.imagePath!);
    }

    return _networkService.postData(
      endPoint: EndPoints.register,
      body: body,
      enableFormData: params.imagePath != null,
    );
  }

  @override
  Future<ApiResponse<dynamic>> verifyOtp({
    required String key,
    required String otp,
  }) {
    return _networkService.postData(
      endPoint: EndPoints.verifyOtp,
      body: {'verify_with': 2, 'key': key, 'otp': otp},
    );
  }

  @override
  Future<ApiResponse<dynamic>> resendVerification({required String key}) {
    return _networkService.postData(
      endPoint: EndPoints.resendVerification,
      body: {'verify_with': 2, 'key': key},
    );
  }

  @override
  Future<ApiResponse<dynamic>> socialLogin({
    required String provider,
    required String accessToken,
    String? idToken,
    String? fcmToken,
  }) {
    return _networkService.postData(
      endPoint: EndPoints.socialLogin(provider),
      body: {
        'access_token': accessToken,
        'id_token': ?idToken,
        'fcm_token': ?fcmToken,
      },
    );
  }

  @override
  Future<ApiResponse<dynamic>> forgotPassword({required String key}) {
    return _networkService.postData(
      endPoint: EndPoints.forgotPassword,
      body: {'verify_with': 2, 'key': key},
    );
  }

  @override
  Future<ApiResponse<dynamic>> verifyResetPassword({
    required String key,
    required String otp,
  }) {
    return _networkService.postData(
      endPoint: EndPoints.verifyResetPassword,
      body: {'verify_with': 2, 'key': key, 'otp': otp},
    );
  }

  @override
  Future<ApiResponse<dynamic>> resetPassword({
    required String password,
    required String passwordConfirmation,
  }) {
    return _networkService.postData(
      endPoint: EndPoints.resetPassword,
      body: {
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
  }

  @override
  Future<ApiResponse<dynamic>> logout() {
    return _networkService.postData(endPoint: EndPoints.logout);
  }
}
