import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:diko_barber/core/di/service_locator.dart';
import '../cubit/splash_cubit.dart';
import '../cubit/splash_state.dart';
import 'splash_animation_view.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SplashCubit>(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashComplete) {
            context.go(state.navigationTarget);
          }
        },
        child: const Scaffold(
          backgroundColor: Colors.white,
          body: SplashAnimationView(),
        ),
      ),
    );
  }
}
