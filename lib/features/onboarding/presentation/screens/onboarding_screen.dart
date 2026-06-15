import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zain/core/di/service_locator.dart';
import '../cubit/onboarding_cubit.dart';
import 'onboarding_view.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OnboardingCubit>(),
      child: const Scaffold(
        backgroundColor: Colors.black,
        body: OnboardingView(),
      ),
    );
  }
}
