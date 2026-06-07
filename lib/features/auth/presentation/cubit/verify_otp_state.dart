import 'package:equatable/equatable.dart';

sealed class VerifyOtpState extends Equatable {
  const VerifyOtpState();
}

final class VerifyOtpFormState extends VerifyOtpState {
  const VerifyOtpFormState({
    this.otp = '',
    this.otpError,
    this.isSubmitting = false,
    this.isResending = false,
    this.countdown = 60,
    this.canResend = false,
  });

  final String otp;
  final String? otpError;
  final bool isSubmitting;
  final bool isResending;
  final int countdown;
  final bool canResend;

  bool get isComplete => otp.length == 4;

  VerifyOtpFormState copyWith({
    String? otp,
    String? Function()? otpError,
    bool? isSubmitting,
    bool? isResending,
    int? countdown,
    bool? canResend,
  }) {
    return VerifyOtpFormState(
      otp: otp ?? this.otp,
      otpError: otpError != null ? otpError() : this.otpError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isResending: isResending ?? this.isResending,
      countdown: countdown ?? this.countdown,
      canResend: canResend ?? this.canResend,
    );
  }

  @override
  List<Object?> get props =>
      [otp, otpError, isSubmitting, isResending, countdown, canResend];
}

final class VerifyOtpSuccess extends VerifyOtpState {
  const VerifyOtpSuccess();

  @override
  List<Object?> get props => [];
}
