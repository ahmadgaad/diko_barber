import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/cache/cache_keys.dart';
import 'package:ronaq_barber/core/cache/secure_storage_cache_client.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/features/auth/domain/use_cases/resend_verification_use_case.dart';
import 'package:ronaq_barber/features/auth/domain/use_cases/verify_otp_use_case.dart';

import 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  VerifyOtpCubit({
    required VerifyOtpUseCase verifyOtpUseCase,
    required ResendVerificationUseCase resendVerificationUseCase,
    required SecureStorageCacheClient secureStorage,
    required this.email,
  }) : _verifyOtpUseCase = verifyOtpUseCase,
       _resendVerificationUseCase = resendVerificationUseCase,
       _secureStorage = secureStorage,
       super(const VerifyOtpFormState()) {
    _startCountdown();
  }

  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResendVerificationUseCase _resendVerificationUseCase;
  final SecureStorageCacheClient _secureStorage;
  final String email;
  Timer? _timer;

  VerifyOtpFormState get _formState => state as VerifyOtpFormState;

  void _startCountdown() {
    _timer?.cancel();
    emit(_formState.copyWith(countdown: 120, canResend: false));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state is! VerifyOtpFormState) {
        timer.cancel();
        return;
      }
      final remaining = _formState.countdown - 1;
      if (remaining <= 0) {
        timer.cancel();
        emit(_formState.copyWith(countdown: 0, canResend: true));
      } else {
        emit(_formState.copyWith(countdown: remaining));
      }
    });
  }

  void onOtpChanged(String value) {
    if (state is! VerifyOtpFormState) return;
    emit(_formState.copyWith(otp: value, otpError: () => null));
  }

  Future<void> verify() async {
    if (state is! VerifyOtpFormState) return;
    if (!_formState.isComplete) return;

    emit(_formState.copyWith(isSubmitting: true));

    final result = await _verifyOtpUseCase(key: email, otp: _formState.otp);

    switch (result) {
      case Success(:final data):
        if (data.token != null) {
          log('Received access token: ${data.token}');
          await _secureStorage.set(CacheKeys.userAccessToken, data.token!);
        }
        await _secureStorage.set(CacheKeys.userIsVerified, 'true');
        emit(const VerifyOtpSuccess());
      case Failure(:final error):
        emit(
          _formState.copyWith(
            isSubmitting: false,
            otpError: () => error.message,
          ),
        );
    }
  }

  Future<void> resend() async {
    if (state is! VerifyOtpFormState) return;
    if (!_formState.canResend) return;

    emit(_formState.copyWith(isResending: true, otpError: () => null));

    final result = await _resendVerificationUseCase(key: email);

    if (state is! VerifyOtpFormState) return;

    switch (result) {
      case Success():
        emit(_formState.copyWith(otp: '', isResending: false));
        _startCountdown();
      case Failure(:final error):
        emit(
          _formState.copyWith(
            isResending: false,
            otpError: () => error.message,
          ),
        );
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
