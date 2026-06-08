import 'package:dio/dio.dart';
import 'package:ronaq_barber/core/networking/api_consumer.dart';
import 'package:ronaq_barber/core/networking/api_response.dart';
import 'package:ronaq_barber/core/networking/endpoints.dart';
import 'package:ronaq_barber/features/salon_auth/domain/entities/salon_register_params.dart';

abstract class SalonAuthRemoteDataSource {
  Future<ApiResponse<dynamic>> register(SalonRegisterParams params);

  Future<ApiResponse<dynamic>> verifyOtp({
    required String key,
    required String otp,
  });

  Future<ApiResponse<dynamic>> resendOtp({required String key});
}

class SalonAuthRemoteDataSourceImpl implements SalonAuthRemoteDataSource {
  const SalonAuthRemoteDataSourceImpl(this._networkService);

  final INetworkService _networkService;

  @override
  Future<ApiResponse<dynamic>> register(SalonRegisterParams params) async {
    final body = <String, dynamic>{
      'owner_name': params.ownerName,
      'name': params.name,
      'phone': params.phone,
      'email': params.email,
      'password': params.password,
      'password_confirmation': params.passwordConfirmation,
      'specialization': params.specialization,
      'categories[]': params.categoryIds,
      'city_id': params.cityId,
      'neighborhood_id': ?params.neighborhoodId,
      'description': ?params.description,
      'location': ?params.location,
      'commercial_registration_number': ?params.commercialRegistrationNumber,
    };

    if (params.logoPath != null) {
      body['logo'] = await MultipartFile.fromFile(params.logoPath!);
    }
    if (params.commercialRegistrationImagePath != null) {
      body['commercial_registration_image'] = await MultipartFile.fromFile(
        params.commercialRegistrationImagePath!,
      );
    }

    return _networkService.postData(
      endPoint: EndPoints.salonRegister,
      body: body,
      enableFormData: true,
    );
  }

  @override
  Future<ApiResponse<dynamic>> verifyOtp({
    required String key,
    required String otp,
  }) => _networkService.postData(
    endPoint: EndPoints.salonVerifyOtp,
    body: {'email': key, 'otp': otp},
  );

  @override
  Future<ApiResponse<dynamic>> resendOtp({required String key}) =>
      _networkService.postData(
        endPoint: EndPoints.salonResendOtp,
        body: {'key': key},
      );
}
