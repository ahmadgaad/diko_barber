import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';

import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  const ResetPasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<ApiErrorModel, void>> call({
    required String password,
    required String passwordConfirmation,
  }) =>
      _repository.resetPassword(
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
}
