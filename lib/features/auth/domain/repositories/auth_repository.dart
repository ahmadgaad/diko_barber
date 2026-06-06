import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';

import '../entities/auth_response.dart';

abstract class AuthRepository {
  Future<Result<ApiErrorModel, AuthResponse>> signIn({
    required String email,
    required String password,
  });

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  });

  Future<void> verifyOtp({required String email, required String otp});
}
