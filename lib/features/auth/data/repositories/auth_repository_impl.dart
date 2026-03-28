import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    // TODO: Replace with actual API call
    await Future<void>.delayed(const Duration(seconds: 1));
  }
}
