import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/di/service_locator.dart';
import 'package:zain/features/auth/presentation/cubit/verify_reset_password_cubit.dart';

import 'verify_reset_password_view.dart';

class VerifyResetPasswordScreen extends StatelessWidget {
  const VerifyResetPasswordScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VerifyResetPasswordCubit>(param1: email),
      child: Scaffold(body: VerifyResetPasswordView(email: email)),
    );
  }
}
