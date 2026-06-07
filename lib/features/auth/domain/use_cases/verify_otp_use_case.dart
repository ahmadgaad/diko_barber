import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';

import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  const VerifyOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<ApiErrorModel, void>> call({
    required String key,
    required String otp,
  }) =>
      _repository.verifyOtp(key: key, otp: otp);
}
