import 'package:equatable/equatable.dart';

sealed class VerifyResetPasswordState extends Equatable {
  const VerifyResetPasswordState();
}

final class VerifyResetPasswordFormState extends VerifyResetPasswordState {
  const VerifyResetPasswordFormState({
    this.otp = '',
    this.otpError,
    this.isSubmitting = false,
  });

  final String otp;
  final String? otpError;
  final bool isSubmitting;

  bool get isComplete => otp.length == 4;

  VerifyResetPasswordFormState copyWith({
    String? otp,
    String? Function()? otpError,
    bool? isSubmitting,
  }) {
    return VerifyResetPasswordFormState(
      otp: otp ?? this.otp,
      otpError: otpError != null ? otpError() : this.otpError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [otp, otpError, isSubmitting];
}

final class VerifyResetPasswordSuccess extends VerifyResetPasswordState {
  const VerifyResetPasswordSuccess();

  @override
  List<Object?> get props => [];
}
