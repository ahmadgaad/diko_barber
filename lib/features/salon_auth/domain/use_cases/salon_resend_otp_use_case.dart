import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/salon_auth/domain/repositories/salon_auth_repository.dart';

class SalonResendOtpUseCase {
  const SalonResendOtpUseCase(this._repository);

  final SalonAuthRepository _repository;

  Future<Result<ApiErrorModel, void>> call({required String key}) =>
      _repository.resendOtp(key: key);
}
