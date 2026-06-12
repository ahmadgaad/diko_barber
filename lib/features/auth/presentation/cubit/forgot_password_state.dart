import 'package:equatable/equatable.dart';

sealed class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();
}

final class ForgotPasswordFormState extends ForgotPasswordState {
  const ForgotPasswordFormState({
    this.email = '',
    this.emailError,
    this.apiError,
    this.isSubmitting = false,
  });

  final String email;
  final String? emailError;
  final String? apiError;
  final bool isSubmitting;

  bool get isValid => email.isNotEmpty && emailError == null;

  ForgotPasswordFormState copyWith({
    String? email,
    String? Function()? emailError,
    String? Function()? apiError,
    bool? isSubmitting,
  }) {
    return ForgotPasswordFormState(
      email: email ?? this.email,
      emailError: emailError != null ? emailError() : this.emailError,
      apiError: apiError != null ? apiError() : this.apiError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [email, emailError, apiError, isSubmitting];
}

final class ForgotPasswordSuccess extends ForgotPasswordState {
  const ForgotPasswordSuccess();

  @override
  List<Object?> get props => [];
}
