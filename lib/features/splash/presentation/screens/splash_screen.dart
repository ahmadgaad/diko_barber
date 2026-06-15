import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zain/core/di/service_locator.dart';
import 'package:zain/core/theme/app_colors.dart';

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
        listenWhen: (_, current) => current is SplashComplete,
        listener: (context, state) async {
          if (state is SplashComplete) {
            await _precacheImages(context, state.imagesToPrecache);
            if (context.mounted) context.go(state.navigationTarget);
          }
        },
        child: const Scaffold(
          backgroundColor: splashOrange,
          body: SplashAnimationView(),
        ),
      ),
    );
  }

  Future<void> _precacheImages(
    BuildContext context,
    List<String> urls,
  ) async {
    await Future.wait([
      for (final url in urls)
        precacheImage(NetworkImage(url), context).catchError((_) {}),
    ]);
  }
}