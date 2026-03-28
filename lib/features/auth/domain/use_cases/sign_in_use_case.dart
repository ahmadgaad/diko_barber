import '../repositories/auth_repository.dart';

class SignInUseCase {
  const SignInUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call({
    required String email,
    required String password,
  }) =>
      _repository.signIn(email: email, password: password);
}
