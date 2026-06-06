import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:ronaq_barber/features/auth/data/models/auth_response_model.dart';
import 'package:ronaq_barber/features/auth/domain/entities/auth_response.dart';
import 'package:ronaq_barber/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Result<ApiErrorModel, AuthResponse>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.signIn(
        login: email,
        password: password,
      );

      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }

      final authResponse = AuthResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      return Success(authResponse);
    } catch (e) {
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    // TODO: implement
  }

  @override
  Future<void> verifyOtp({required String email, required String otp}) async {
    // TODO: implement
  }
}
