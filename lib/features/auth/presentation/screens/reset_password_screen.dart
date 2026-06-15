import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/di/service_locator.dart';
import 'package:zain/features/auth/presentation/cubit/reset_password_cubit.dart';

import 'reset_password_view.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ResetPasswordCubit>(),
      child: const Scaffold(body: ResetPasswordView()),
    );
  }
}
