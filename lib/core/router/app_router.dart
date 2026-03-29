import 'package:diko_barber/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:diko_barber/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:diko_barber/features/auth/presentation/screens/verify_otp_screen.dart';
import 'package:diko_barber/features/home/presentation/screens/home_screen.dart';
import 'package:diko_barber/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:diko_barber/features/splash/presentation/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

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
      builder: (context, state) => const HomeScreen(),
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
