import '../repositories/auth_repository.dart';

class SignUpUseCase {
  const SignUpUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call({
    required String fullName,
    required String email,
    required String password,
  }) =>
      _repository.signUp(fullName: fullName, email: email, password: password);
}
