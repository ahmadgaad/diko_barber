import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/di/service_locator.dart';
import 'package:zain/features/salon_auth/presentation/cubit/salon_verify_otp_cubit.dart';

import 'salon_verify_otp_view.dart';

class SalonVerifyOtpScreen extends StatelessWidget {
  const SalonVerifyOtpScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl.get<SalonVerifyOtpCubit>(param1: email),
      child: Scaffold(body: SalonVerifyOtpView(email: email)),
    );
  }
}
