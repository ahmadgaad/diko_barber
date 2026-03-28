import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:diko_barber/core/router/app_routes.dart';
import 'package:diko_barber/features/auth/domain/use_cases/sign_up_use_case.dart';

import 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({required SignUpUseCase signUpUseCase})
      : _signUpUseCase = signUpUseCase,
        super(const SignUpFormState());

  final SignUpUseCase _signUpUseCase;

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  SignUpFormState get _formState => state as SignUpFormState;

  void onFullNameChanged(String value) {
    if (state is! SignUpFormState) return;
    emit(_formState.copyWith(
      fullName: value,
      fullNameError: () => null,
    ));
  }

  void onEmailChanged(String value) {
    if (state is! SignUpFormState) return;
    emit(_formState.copyWith(
      email: value,
      emailError: () => null,
    ));
  }

  void onPasswordChanged(String value) {
    if (state is! SignUpFormState) return;
    emit(_formState.copyWith(
      password: value,
      passwordError: () => null,
    ));
  }

  void togglePasswordVisibility() {
    if (state is! SignUpFormState) return;
    emit(_formState.copyWith(
      obscurePassword: !_formState.obscurePassword,
    ));
  }

  Future<void> signUp() async {
    if (state is! SignUpFormState) return;

    final fullNameError = _validateFullName(_formState.fullName);
    final emailError = _validateEmail(_formState.email);
    final passwordError = _validatePassword(_formState.password);

    if (fullNameError != null || emailError != null || passwordError != null) {
      emit(_formState.copyWith(
        fullNameError: () => fullNameError,
        emailError: () => emailError,
        passwordError: () => passwordError,
      ));
      return;
    }

    emit(_formState.copyWith(isSubmitting: true));

    try {
      await _signUpUseCase(
        fullName: _formState.fullName,
        email: _formState.email,
        password: _formState.password,
      );
      emit(SignUpSuccess(email: _formState.email));
    } on Exception {
      emit(_formState.copyWith(isSubmitting: false));
    }
  }

  void navigateToSignIn() {
    emit(const SignUpNavigate(target: AppRoutes.login));
  }

  String? _validateFullName(String value) {
    if (value.isEmpty) return 'auth.full_name_required';
    return null;
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) return 'auth.email_required';
    if (!_emailRegex.hasMatch(email)) return 'auth.email_invalid';
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) return 'auth.password_required';
    if (password.length < 8) return 'auth.password_min_length';
    return null;
  }
}
