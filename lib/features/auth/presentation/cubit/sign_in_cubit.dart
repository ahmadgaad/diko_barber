import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:ronaq_barber/core/cache/cache_keys.dart';
import 'package:ronaq_barber/core/cache/secure_storage_cache_client.dart';
import 'package:ronaq_barber/core/cache/shared_pref_cache_client.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/core/router/app_routes.dart';
import 'package:ronaq_barber/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:ronaq_barber/features/auth/domain/use_cases/social_login_use_case.dart';

import 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit({
    required SignInUseCase signInUseCase,
    required SocialLoginUseCase socialLoginUseCase,
    required SecureStorageCacheClient secureStorage,
    required SharedPrefCacheClient cache,
  })  : _signInUseCase = signInUseCase,
        _socialLoginUseCase = socialLoginUseCase,
        _secureStorage = secureStorage,
        _cache = cache,
        super(const SignInFormState());

  final SignInUseCase _signInUseCase;
  final SocialLoginUseCase _socialLoginUseCase;
  final SecureStorageCacheClient _secureStorage;
  final SharedPrefCacheClient _cache;

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final _phoneRegex = RegExp(r'^[+]?[0-9]{7,15}$');

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

    final emailError = _validateLogin(_formState.email);
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
        if (data.token != null) {
          await _secureStorage.set(CacheKeys.userAccessToken, data.token!);
        }
        await _secureStorage.set(CacheKeys.userIsVerified, data.isVerified.toString());
        await _secureStorage.set(CacheKeys.userName, data.user.name);
        if (data.user.location != null && data.user.location!.isNotEmpty) {
          await _cache.set(CacheKeys.userLocation, data.user.location!);
        }
        if (data.isVerified) {
          emit(const SignInSuccess());
        } else {
          final current = _formState.copyWith(isSubmitting: false, apiError: () => null);
          emit(SignInNeedsVerification(contact: _formState.email));
          emit(current);
        }
      case Failure(:final error):
        emit(_formState.copyWith(
          isSubmitting: false,
          apiError: () => error.message,
        ));
    }
  }

  Future<void> loginWithFacebook() async {
    if (state is! SignInFormState) return;

    emit(_formState.copyWith(isSubmitting: true, apiError: () => null));

    final loginResult = await FacebookAuth.instance.login();

    if (loginResult.status != LoginStatus.success) {
      emit(_formState.copyWith(isSubmitting: false));
      return;
    }

    final accessToken = loginResult.accessToken!.tokenString;

    final result = await _socialLoginUseCase(
      provider: 'facebook',
      accessToken: accessToken,
    );

    switch (result) {
      case Success(:final data):
        if (data.token != null) {
          await _secureStorage.set(CacheKeys.userAccessToken, data.token!);
        }
        await _secureStorage.set(CacheKeys.userIsVerified, data.isVerified.toString());
        await _secureStorage.set(CacheKeys.userName, data.user.name);
        if (data.user.location != null && data.user.location!.isNotEmpty) {
          await _cache.set(CacheKeys.userLocation, data.user.location!);
        }
        emit(const SignInSuccess());
      case Failure(:final error):
        emit(_formState.copyWith(
          isSubmitting: false,
          apiError: () => error.message,
        ));
    }
  }

  void navigateToSignUp() {
    final current = _formState.copyWith(apiError: () => null);
    emit(const SignInNavigate(target: AppRoutes.signup));
    emit(current);
  }

  void navigateToForgotPassword() {
    final current = _formState.copyWith(apiError: () => null);
    emit(const SignInNavigate(target: AppRoutes.forgotPassword));
    emit(current);
  }

  String? _validateLogin(String value) {
    if (value.isEmpty) return 'auth.login_required';
    final isEmail = _emailRegex.hasMatch(value);
    final isPhone = _phoneRegex.hasMatch(value);
    if (!isEmail && !isPhone) return 'auth.login_invalid';
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) return 'auth.password_required';
    return null;
  }
}
