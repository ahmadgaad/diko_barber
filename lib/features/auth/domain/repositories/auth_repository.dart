abstract class AuthRepository {
  Future<void> signIn({required String email, required String password});
  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  });
  Future<void> verifyOtp({required String email, required String otp});
}
