import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:diko_barber/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:diko_barber/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:diko_barber/features/auth/presentation/screens/verify_otp_screen.dart';
import 'package:diko_barber/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:diko_barber/features/splash/presentation/screens/splash_screen.dart';
import 'app_routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const _HomePlaceholder(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: AppRoutes.verifyOtp,
      builder: (context, state) =>
          VerifyOtpScreen(email: state.extra as String),
    ),
  ],
);

class _HomePlaceholder extends StatelessWidget {
  const _HomePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Coming Soon')));
  }
}
