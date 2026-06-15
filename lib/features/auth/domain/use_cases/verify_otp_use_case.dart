import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';

import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  const VerifyOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<ApiErrorModel, AuthResponse>> call({
    required String key,
    required String otp,
  }) =>
      _repository.verifyOtp(key: key, otp: otp);
}
