import 'package:equatable/equatable.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();
}

final class SignUpFormState extends SignUpState {
  const SignUpFormState({
    this.fullName = '',
    this.email = '',
    this.password = '',
    this.fullNameError,
    this.emailError,
    this.passwordError,
    this.obscurePassword = true,
    this.isSubmitting = false,
  });

  final String fullName;
  final String email;
  final String password;
  final String? fullNameError;
  final String? emailError;
  final String? passwordError;
  final bool obscurePassword;
  final bool isSubmitting;

  bool get isValid =>
      fullName.isNotEmpty &&
      email.isNotEmpty &&
      password.isNotEmpty &&
      fullNameError == null &&
      emailError == null &&
      passwordError == null;

  SignUpFormState copyWith({
    String? fullName,
    String? email,
    String? password,
    String? Function()? fullNameError,
    String? Function()? emailError,
    String? Function()? passwordError,
    bool? obscurePassword,
    bool? isSubmitting,
  }) {
    return SignUpFormState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      fullNameError: fullNameError != null ? fullNameError() : this.fullNameError,
      emailError: emailError != null ? emailError() : this.emailError,
      passwordError: passwordError != null ? passwordError() : this.passwordError,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        email,
        password,
        fullNameError,
        emailError,
        passwordError,
        obscurePassword,
        isSubmitting,
      ];
}

final class SignUpSuccess extends SignUpState {
  const SignUpSuccess();

  @override
  List<Object?> get props => [];
}

final class SignUpNavigate extends SignUpState {
  const SignUpNavigate({required this.target});

  final String target;

  @override
  List<Object?> get props => [target];
}
