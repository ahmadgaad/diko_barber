import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:diko_barber/features/auth/presentation/screens/sign_in_screen.dart';
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
      builder: (context, state) => const _SignupPlaceholder(),
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

class _SignupPlaceholder extends StatelessWidget {
  const _SignupPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Sign Up — Coming Soon')));
  }
}
