import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/features/salon_auth/domain/repositories/salon_auth_repository.dart';

class SalonResendOtpUseCase {
  const SalonResendOtpUseCase(this._repository);

  final SalonAuthRepository _repository;

  Future<Result<ApiErrorModel, void>> call({required String key}) =>
      _repository.resendOtp(key: key);
}
