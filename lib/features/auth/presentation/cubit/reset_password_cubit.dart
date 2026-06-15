import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/auth/domain/use_cases/reset_password_use_case.dart';

import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this._resetPasswordUseCase)
      : super(const ResetPasswordFormState());

  final ResetPasswordUseCase _resetPasswordUseCase;

  ResetPasswordFormState get _formState => state as ResetPasswordFormState;

  void onPasswordChanged(String value) {
    if (state is! ResetPasswordFormState) return;
    emit(_formState.copyWith(password: value, passwordError: () => null));
  }

  void onPasswordConfirmationChanged(String value) {
    if (state is! ResetPasswordFormState) return;
    emit(_formState.copyWith(
      passwordConfirmation: value,
      passwordConfirmationError: () => null,
    ));
  }

  void togglePasswordVisibility() {
    if (state is! ResetPasswordFormState) return;
    emit(_formState.copyWith(isPasswordVisible: !_formState.isPasswordVisible));
  }

  void toggleConfirmVisibility() {
    if (state is! ResetPasswordFormState) return;
    emit(_formState.copyWith(isConfirmVisible: !_formState.isConfirmVisible));
  }

  Future<void> submit() async {
    if (state is! ResetPasswordFormState) return;

    final passwordError = _validatePassword(_formState.password);
    final confirmError = _validateConfirmation(
      _formState.password,
      _formState.passwordConfirmation,
    );

    if (passwordError != null || confirmError != null) {
      emit(_formState.copyWith(
        passwordError: () => passwordError,
        passwordConfirmationError: () => confirmError,
      ));
      return;
    }

    emit(_formState.copyWith(isSubmitting: true));

    final result = await _resetPasswordUseCase(
      password: _formState.password,
      passwordConfirmation: _formState.passwordConfirmation,
    );

    switch (result) {
      case Success():
        emit(const ResetPasswordSuccess());
      case Failure(:final error):
        emit(_formState.copyWith(
          isSubmitting: false,
          passwordError: () => error.message,
        ));
    }
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) return 'auth.password_required';
    if (value.length < 8) return 'auth.password_min_length';
    return null;
  }

  String? _validateConfirmation(String password, String confirmation) {
    if (confirmation.isEmpty) return 'auth.password_confirmation_required';
    if (password != confirmation) return 'auth.password_confirmation_mismatch';
    return null;
  }
}
