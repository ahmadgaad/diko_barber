import 'package:equatable/equatable.dart';

sealed class SignInState extends Equatable {
  const SignInState();
}

final class SignInFormState extends SignInState {
  const SignInFormState({
    this.email = '',
    this.password = '',
    this.emailError,
    this.passwordError,
    this.apiError,
    this.obscurePassword = true,
    this.isSubmitting = false,
  });

  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final String? apiError;
  final bool obscurePassword;
  final bool isSubmitting;

  bool get isValid =>
      email.isNotEmpty &&
      password.isNotEmpty &&
      emailError == null &&
      passwordError == null;

  SignInFormState copyWith({
    String? email,
    String? password,
    String? Function()? emailError,
    String? Function()? passwordError,
    String? Function()? apiError,
    bool? obscurePassword,
    bool? isSubmitting,
  }) {
    return SignInFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError != null ? emailError() : this.emailError,
      passwordError:
          passwordError != null ? passwordError() : this.passwordError,
      apiError: apiError != null ? apiError() : this.apiError,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        emailError,
        passwordError,
        apiError,
        obscurePassword,
        isSubmitting,
      ];
}

final class SignInSuccess extends SignInState {
  const SignInSuccess();

  @override
  List<Object?> get props => [];
}

final class SignInNeedsVerification extends SignInState {
  const SignInNeedsVerification({required this.contact});

  final String contact;

  @override
  List<Object?> get props => [contact];
}

final class SignInNavigate extends SignInState {
  const SignInNavigate({required this.target});

  final String target;

  @override
  List<Object?> get props => [target];
}
