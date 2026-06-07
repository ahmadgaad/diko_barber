import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';

import '../entities/auth_response.dart';
import '../entities/sign_up_params.dart';

abstract class AuthRepository {
  Future<Result<ApiErrorModel, AuthResponse>> signIn({
    required String email,
    required String password,
  });

  Future<Result<ApiErrorModel, AuthResponse>> signUp(SignUpParams params);

  Future<Result<ApiErrorModel, void>> verifyOtp({
    required String key,
    required String otp,
  });

  Future<Result<ApiErrorModel, void>> resendVerification({required String key});

  Future<Result<ApiErrorModel, AuthResponse>> socialLogin({
    required String provider,
    required String accessToken,
    String? idToken,
    String? fcmToken,
  });
}
