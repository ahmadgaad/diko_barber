import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/cache/cache_keys.dart';
import 'package:ronaq_barber/core/cache/secure_storage_cache_client.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/features/auth/domain/use_cases/verify_reset_password_use_case.dart';

import 'verify_reset_password_state.dart';

class VerifyResetPasswordCubit extends Cubit<VerifyResetPasswordState> {
  VerifyResetPasswordCubit({
    required VerifyResetPasswordUseCase verifyResetPasswordUseCase,
    required SecureStorageCacheClient secureStorage,
    required this.email,
  })  : _verifyResetPasswordUseCase = verifyResetPasswordUseCase,
        _secureStorage = secureStorage,
        super(const VerifyResetPasswordFormState());

  final VerifyResetPasswordUseCase _verifyResetPasswordUseCase;
  final SecureStorageCacheClient _secureStorage;
  final String email;

  VerifyResetPasswordFormState get _formState =>
      state as VerifyResetPasswordFormState;

  void onOtpChanged(String value) {
    if (state is! VerifyResetPasswordFormState) return;
    emit(_formState.copyWith(otp: value, otpError: () => null));
  }

  Future<void> verify() async {
    if (state is! VerifyResetPasswordFormState) return;
    if (!_formState.isComplete) return;

    emit(_formState.copyWith(isSubmitting: true));

    final result = await _verifyResetPasswordUseCase(
      key: email,
      otp: _formState.otp,
    );

    switch (result) {
      case Success(:final data):
        if (data.token != null) {
          await _secureStorage.set(CacheKeys.userAccessToken, data.token!);
        }
        emit(const VerifyResetPasswordSuccess());
      case Failure(:final error):
        emit(_formState.copyWith(
          isSubmitting: false,
          otpError: () => error.message,
        ));
    }
  }
}
