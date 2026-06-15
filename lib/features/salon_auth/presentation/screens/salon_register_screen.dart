import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/di/service_locator.dart';
import 'package:zain/features/salon_auth/presentation/cubit/salon_register_cubit.dart';

import 'salon_register_view.dart';

class SalonRegisterScreen extends StatelessWidget {
  const SalonRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SalonRegisterCubit>(),
      child: const Scaffold(body: SalonRegisterView()),
    );
  }
}
