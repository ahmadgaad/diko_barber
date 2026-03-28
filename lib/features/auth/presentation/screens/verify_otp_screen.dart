import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:diko_barber/core/di/service_locator.dart';
import 'package:diko_barber/features/auth/presentation/cubit/verify_otp_cubit.dart';

import 'verify_otp_view.dart';

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VerifyOtpCubit>(param1: email),
      child: Scaffold(body: VerifyOtpView(email: email)),
    );
  }
}
