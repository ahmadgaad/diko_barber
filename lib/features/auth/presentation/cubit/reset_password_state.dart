import 'package:equatable/equatable.dart';

sealed class ResetPasswordState extends Equatable {
  const ResetPasswordState();
}

final class ResetPasswordFormState extends ResetPasswordState {
  const ResetPasswordFormState({
    this.password = '',
    this.passwordError,
    this.passwordConfirmation = '',
    this.passwordConfirmationError,
    this.isSubmitting = false,
    this.isPasswordVisible = false,
    this.isConfirmVisible = false,
  });

  final String password;
  final String? passwordError;
  final String passwordConfirmation;
  final String? passwordConfirmationError;
  final bool isSubmitting;
  final bool isPasswordVisible;
  final bool isConfirmVisible;

  bool get isValid =>
      password.isNotEmpty &&
      passwordConfirmation.isNotEmpty &&
      passwordError == null &&
      passwordConfirmationError == null;

  ResetPasswordFormState copyWith({
    String? password,
    String? Function()? passwordError,
    String? passwordConfirmation,
    String? Function()? passwordConfirmationError,
    bool? isSubmitting,
    bool? isPasswordVisible,
    bool? isConfirmVisible,
  }) {
    return ResetPasswordFormState(
      password: password ?? this.password,
      passwordError:
          passwordError != null ? passwordError() : this.passwordError,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      passwordConfirmationError: passwordConfirmationError != null
          ? passwordConfirmationError()
          : this.passwordConfirmationError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmVisible: isConfirmVisible ?? this.isConfirmVisible,
    );
  }

  @override
  List<Object?> get props => [
        password,
        passwordError,
        passwordConfirmation,
        passwordConfirmationError,
        isSubmitting,
        isPasswordVisible,
        isConfirmVisible,
      ];
}

final class ResetPasswordSuccess extends ResetPasswordState {
  const ResetPasswordSuccess();

  @override
  List<Object?> get props => [];
}
