import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';

import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  const ForgotPasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<ApiErrorModel, void>> call({required String key}) =>
      _repository.forgotPassword(key: key);
}
