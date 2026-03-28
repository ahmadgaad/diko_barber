import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:diko_barber/core/di/service_locator.dart';
import 'package:diko_barber/features/auth/presentation/cubit/sign_up_cubit.dart';

import 'sign_up_view.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SignUpCubit>(),
      child: const Scaffold(body: SignUpView()),
    );
  }
}
