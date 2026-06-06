import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/cache/cache_keys.dart';
import 'package:ronaq_barber/core/cache/secure_storage_cache_client.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/core/router/app_routes.dart';
import 'package:ronaq_barber/features/auth/domain/use_cases/sign_in_use_case.dart';

import 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit({
    required SignInUseCase signInUseCase,
    required SecureStorageCacheClient secureStorage,
  })  : _signInUseCase = signInUseCase,
        _secureStorage = secureStorage,
        super(const SignInFormState());

  final SignInUseCase _signInUseCase;
  final SecureStorageCacheClient _secureStorage;

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  SignInFormState get _formState => state as SignInFormState;

  void onEmailChanged(String value) {
    if (state is! SignInFormState) return;
    emit(_formState.copyWith(email: value, emailError: () => null, apiError: () => null));
  }

  void onPasswordChanged(String value) {
    if (state is! SignInFormState) return;
    emit(_formState.copyWith(password: value, passwordError: () => null, apiError: () => null));
  }

  void togglePasswordVisibility() {
    if (state is! SignInFormState) return;
    emit(_formState.copyWith(obscurePassword: !_formState.obscurePassword));
  }

  Future<void> signIn() async {
    if (state is! SignInFormState) return;

    final emailError = _validateEmail(_formState.email);
    final passwordError = _validatePassword(_formState.password);

    if (emailError != null || passwordError != null) {
      emit(_formState.copyWith(
        emailError: () => emailError,
        passwordError: () => passwordError,
      ));
      return;
    }

    emit(_formState.copyWith(isSubmitting: true, apiError: () => null));

    final result = await _signInUseCase(
      email: _formState.email,
      password: _formState.password,
    );

    switch (result) {
      case Success(:final data):
        await _secureStorage.set(CacheKeys.userAccessToken, data.token);
        emit(const SignInSuccess());
      case Failure(:final error):
        emit(_formState.copyWith(
          isSubmitting: false,
          apiError: () => error.message,
        ));
    }
  }

  void navigateToSignUp() {
    emit(const SignInNavigate(target: AppRoutes.signup));
  }

  void navigateToForgotPassword() {
    // TODO: Implement forgot password navigation
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) return 'auth.email_required';
    if (!_emailRegex.hasMatch(email)) return 'auth.email_invalid';
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) return 'auth.password_required';
    return null;
  }
}
