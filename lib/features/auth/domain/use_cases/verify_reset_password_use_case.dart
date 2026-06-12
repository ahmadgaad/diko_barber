import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/features/auth/domain/entities/auth_response.dart';

import '../repositories/auth_repository.dart';

class VerifyResetPasswordUseCase {
  const VerifyResetPasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<ApiErrorModel, AuthResponse>> call({
    required String key,
    required String otp,
  }) =>
      _repository.verifyResetPassword(key: key, otp: otp);
}
