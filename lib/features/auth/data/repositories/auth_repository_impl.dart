import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:zain/features/auth/data/models/auth_response_model.dart';
import 'package:zain/features/auth/domain/entities/auth_response.dart';
import 'package:zain/features/auth/domain/entities/sign_up_params.dart';
import 'package:zain/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Result<ApiErrorModel, AuthResponse>> signIn({
    required String email,
    required String password,
    String? fcmToken,
  }) async {
    try {
      final response = await _remoteDataSource.signIn(
        login: email,
        password: password,
        fcmToken: fcmToken,
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
  Future<Result<ApiErrorModel, AuthResponse>> signUp(
    SignUpParams params,
  ) async {
    try {
      final response = await _remoteDataSource.signUp(params);

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
  Future<Result<ApiErrorModel, AuthResponse>> verifyOtp({
    required String key,
    required String otp,
  }) async {
    try {
      final response = await _remoteDataSource.verifyOtp(key: key, otp: otp);
      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }
      final authResponse = AuthResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      return Success(authResponse);
    } catch (_) {
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Result<ApiErrorModel, void>> resendVerification({
    required String key,
  }) async {
    try {
      final response = await _remoteDataSource.resendVerification(key: key);
      if (response.isError) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }
      return const Success(null);
    } catch (_) {
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Result<ApiErrorModel, AuthResponse>> socialLogin({
    required String provider,
    required String accessToken,
    String? idToken,
    String? fcmToken,
  }) async {
    try {
      final response = await _remoteDataSource.socialLogin(
        provider: provider,
        accessToken: accessToken,
        idToken: idToken,
        fcmToken: fcmToken,
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
    } catch (_) {
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Result<ApiErrorModel, void>> forgotPassword({
    required String key,
  }) async {
    try {
      final response = await _remoteDataSource.forgotPassword(key: key);
      if (response.isError) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }
      return const Success(null);
    } catch (_) {
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Result<ApiErrorModel, AuthResponse>> verifyResetPassword({
    required String key,
    required String otp,
  }) async {
    try {
      final response = await _remoteDataSource.verifyResetPassword(
        key: key,
        otp: otp,
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
    } catch (_) {
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Result<ApiErrorModel, void>> resetPassword({
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _remoteDataSource.resetPassword(
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      if (response.isError) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }
      return const Success(null);
    } catch (_) {
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Result<ApiErrorModel, void>> updateLocation({
    required double lat,
    required double long,
    required String location,
  }) async {
    try {
      final response = await _remoteDataSource.updateLocation(
        lat: lat,
        long: long,
        location: location,
      );
      if (response.isError) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }
      return const Success(null);
    } catch (_) {
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Result<ApiErrorModel, void>> logout() async {
    try {
      final response = await _remoteDataSource.logout();
      if (response.isError) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }
      return const Success(null);
    } catch (_) {
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }
}
