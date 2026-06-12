import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/features/salon_auth/domain/entities/salon_register_params.dart';

abstract class SalonAuthRepository {
  Future<Result<ApiErrorModel, void>> register(SalonRegisterParams params);

  Future<Result<ApiErrorModel, void>> verifyOtp({
    required String key,
    required String otp,
  });

  Future<Result<ApiErrorModel, void>> resendOtp({required String key});
}
