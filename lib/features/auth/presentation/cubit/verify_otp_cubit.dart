import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ronaq_barber/features/auth/domain/use_cases/verify_otp_use_case.dart';

import 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  VerifyOtpCubit({
    required VerifyOtpUseCase verifyOtpUseCase,
    required this.email,
  })  : _verifyOtpUseCase = verifyOtpUseCase,
        super(const VerifyOtpFormState()) {
    _startCountdown();
  }

  final VerifyOtpUseCase _verifyOtpUseCase;
  final String email;
  Timer? _timer;

  VerifyOtpFormState get _formState => state as VerifyOtpFormState;

  void _startCountdown() {
    _timer?.cancel();
    emit(_formState.copyWith(countdown: 60, canResend: false));
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
    emit(_formState.copyWith(
      otp: value,
      otpError: () => null,
    ));
  }

  Future<void> verify() async {
    if (state is! VerifyOtpFormState) return;
    if (!_formState.isComplete) return;

    emit(_formState.copyWith(isSubmitting: true));

    try {
      await _verifyOtpUseCase(email: email, otp: _formState.otp);
      emit(const VerifyOtpSuccess());
    } on Exception {
      emit(_formState.copyWith(
        isSubmitting: false,
        otpError: () => 'auth.otp_invalid',
      ));
    }
  }

  void resend() {
    if (state is! VerifyOtpFormState) return;
    if (!_formState.canResend) return;
    emit(_formState.copyWith(otp: '', otpError: () => null));
    _startCountdown();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
