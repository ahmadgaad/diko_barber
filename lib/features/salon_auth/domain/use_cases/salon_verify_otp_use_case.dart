import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/salon_auth/domain/repositories/salon_auth_repository.dart';

class SalonVerifyOtpUseCase {
  const SalonVerifyOtpUseCase(this._repository);

  final SalonAuthRepository _repository;

  Future<Result<ApiErrorModel, void>> call({
    required String key,
    required String otp,
  }) =>
      _repository.verifyOtp(key: key, otp: otp);
}
