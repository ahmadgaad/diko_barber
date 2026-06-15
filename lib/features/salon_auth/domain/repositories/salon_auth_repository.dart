import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/salon_auth/domain/entities/salon_register_params.dart';

abstract class SalonAuthRepository {
  Future<Result<ApiErrorModel, void>> register(SalonRegisterParams params);

  Future<Result<ApiErrorModel, void>> verifyOtp({
    required String key,
    required String otp,
  });

  Future<Result<ApiErrorModel, void>> resendOtp({required String key});
}
