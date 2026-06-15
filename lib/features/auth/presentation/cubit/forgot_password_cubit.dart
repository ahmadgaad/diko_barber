import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/auth/domain/use_cases/forgot_password_use_case.dart';

import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._forgotPasswordUseCase)
      : super(const ForgotPasswordFormState());

  final ForgotPasswordUseCase _forgotPasswordUseCase;

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  ForgotPasswordFormState get _formState => state as ForgotPasswordFormState;

  void onEmailChanged(String value) {
    if (state is! ForgotPasswordFormState) return;
    emit(_formState.copyWith(email: value, emailError: () => null));
  }

  Future<void> submit() async {
    if (state is! ForgotPasswordFormState) return;

    final emailError = _validateEmail(_formState.email);
    if (emailError != null) {
      emit(_formState.copyWith(emailError: () => emailError));
      return;
    }

    emit(_formState.copyWith(isSubmitting: true, apiError: () => null));

    final result = await _forgotPasswordUseCase(key: _formState.email);

    switch (result) {
      case Success():
        final current = _formState.copyWith(isSubmitting: false);
        emit(const ForgotPasswordSuccess());
        emit(current);
      case Failure(:final error):
        emit(_formState.copyWith(
          isSubmitting: false,
          apiError: () => error.message,
        ));
    }
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) return 'auth.email_required';
    if (!_emailRegex.hasMatch(value)) return 'auth.email_invalid';
    return null;
  }
}
