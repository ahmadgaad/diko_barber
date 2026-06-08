import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/features/salon_auth/data/data_sources/salon_auth_remote_data_source.dart';
import 'package:ronaq_barber/features/salon_auth/domain/entities/salon_register_params.dart';
import 'package:ronaq_barber/features/salon_auth/domain/repositories/salon_auth_repository.dart';

class SalonAuthRepositoryImpl implements SalonAuthRepository {
  const SalonAuthRepositoryImpl(this._remoteDataSource);

  final SalonAuthRemoteDataSource _remoteDataSource;

  @override
  Future<Result<ApiErrorModel, void>> register(
    SalonRegisterParams params,
  ) async {
    try {
      final response = await _remoteDataSource.register(params);
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
  Future<Result<ApiErrorModel, void>> verifyOtp({
    required String key,
    required String otp,
  }) async {
    try {
      final response = await _remoteDataSource.verifyOtp(key: key, otp: otp);
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
  Future<Result<ApiErrorModel, void>> resendOtp({required String key}) async {
    try {
      final response = await _remoteDataSource.resendOtp(key: key);
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
