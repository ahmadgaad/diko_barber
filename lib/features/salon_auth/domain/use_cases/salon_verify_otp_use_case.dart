import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/features/salon_auth/domain/repositories/salon_auth_repository.dart';

class SalonVerifyOtpUseCase {
  const SalonVerifyOtpUseCase(this._repository);

  final SalonAuthRepository _repository;

  Future<Result<ApiErrorModel, void>> call({
    required String key,
    required String otp,
  }) =>
      _repository.verifyOtp(key: key, otp: otp);
}
