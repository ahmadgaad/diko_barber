import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/salon_auth/domain/use_cases/salon_resend_otp_use_case.dart';
import 'package:zain/features/salon_auth/domain/use_cases/salon_verify_otp_use_case.dart';

import 'salon_verify_otp_state.dart';

class SalonVerifyOtpCubit extends Cubit<SalonVerifyOtpState> {
  SalonVerifyOtpCubit({
    required SalonVerifyOtpUseCase verifyOtpUseCase,
    required SalonResendOtpUseCase resendOtpUseCase,
    required this.email,
  })  : _verifyOtpUseCase = verifyOtpUseCase,
        _resendOtpUseCase = resendOtpUseCase,
        super(const SalonVerifyOtpFormState()) {
    _startCountdown();
  }

  final SalonVerifyOtpUseCase _verifyOtpUseCase;
  final SalonResendOtpUseCase _resendOtpUseCase;
  final String email;
  Timer? _timer;

  SalonVerifyOtpFormState get _formState => state as SalonVerifyOtpFormState;

  void _startCountdown() {
    _timer?.cancel();
    emit(_formState.copyWith(countdown: 120, canResend: false));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state is! SalonVerifyOtpFormState) {
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
    if (state is! SalonVerifyOtpFormState) return;
    emit(_formState.copyWith(otp: value, otpError: () => null));
  }

  Future<void> verify() async {
    if (state is! SalonVerifyOtpFormState) return;
    if (!_formState.isComplete) return;

    emit(_formState.copyWith(isSubmitting: true));

    final result =
        await _verifyOtpUseCase(key: email, otp: _formState.otp);

    switch (result) {
      case Success():
        emit(const SalonVerifyOtpSuccess());
      case Failure(:final error):
        emit(_formState.copyWith(
          isSubmitting: false,
          otpError: () => error.message,
        ));
    }
  }

  Future<void> resend() async {
    if (state is! SalonVerifyOtpFormState) return;
    if (!_formState.canResend) return;

    emit(_formState.copyWith(isResending: true, otpError: () => null));

    final result = await _resendOtpUseCase(key: email);

    if (state is! SalonVerifyOtpFormState) return;

    switch (result) {
      case Success():
        emit(_formState.copyWith(otp: '', isResending: false));
        _startCountdown();
      case Failure(:final error):
        emit(_formState.copyWith(
          isResending: false,
          otpError: () => error.message,
        ));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
