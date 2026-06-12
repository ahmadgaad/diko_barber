import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/features/auth/domain/entities/auth_response.dart';
import 'package:ronaq_barber/features/auth/domain/entities/sign_up_params.dart';

import '../repositories/auth_repository.dart';

class SignUpUseCase {
  const SignUpUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<ApiErrorModel, AuthResponse>> call(SignUpParams params) =>
      _repository.signUp(params);
}
