import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/observers/app_router_observer.dart';
import 'package:ronaq_barber/features/book_appointment/presentation/book_appointment_args.dart';
import 'package:ronaq_barber/features/book_appointment/presentation/screens/book_appointment_screen.dart';
import 'package:ronaq_barber/features/explore/presentation/cubit/explore_cubit.dart';
import 'package:ronaq_barber/features/explore/presentation/screens/explore_map_screen.dart';
import 'package:ronaq_barber/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:ronaq_barber/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:ronaq_barber/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:ronaq_barber/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:ronaq_barber/features/auth/presentation/screens/verify_otp_screen.dart';
import 'package:ronaq_barber/features/auth/presentation/screens/verify_reset_password_screen.dart';
import 'package:ronaq_barber/features/home/presentation/screens/home_screen.dart';
import 'package:ronaq_barber/features/salon_details/presentation/screens/salon_details_args.dart';
import 'package:ronaq_barber/features/salon_details/presentation/screens/salon_details_screen.dart';
import 'package:ronaq_barber/features/search/presentation/screens/search_screen.dart';
import 'package:ronaq_barber/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:ronaq_barber/features/salon_auth/presentation/screens/salon_register_screen.dart';
import 'package:ronaq_barber/features/salon_auth/presentation/screens/salon_register_success_screen.dart';
import 'package:ronaq_barber/features/salon_auth/presentation/screens/salon_verify_otp_screen.dart';
import 'package:ronaq_barber/features/splash/presentation/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  observers: [AppRouterObserver()],
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
      path: AppRoutes.search,
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: AppRoutes.exploreMap,
      builder: (context, state) => BlocProvider.value(
        value: state.extra as ExploreCubit,
        child: const ExploreMapScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.salonDetails,
      builder: (context, state) => SalonDetailsScreen(
        salonId: int.parse(state.pathParameters['id']!),
        args: state.extra as SalonDetailsArgs?,
      ),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      pageBuilder: (context, state) => state.extra == 'toggle'
          ? const NoTransitionPage(child: SignUpScreen())
          : const MaterialPage(child: SignUpScreen()),
    ),
    GoRoute(
      path: AppRoutes.verifyOtp,
      builder: (context, state) =>
          VerifyOtpScreen(email: state.extra as String),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.verifyResetPassword,
      builder: (context, state) =>
          VerifyResetPasswordScreen(email: state.extra as String),
    ),
    GoRoute(
      path: AppRoutes.resetPassword,
      builder: (context, state) => const ResetPasswordScreen(),
    ),
    // Salon Auth
    GoRoute(
      path: AppRoutes.salonSignup,
      pageBuilder: (context, state) => state.extra == 'toggle'
          ? const NoTransitionPage(child: SalonRegisterScreen())
          : const MaterialPage(child: SalonRegisterScreen()),
    ),
    GoRoute(
      path: AppRoutes.salonVerifyOtp,
      builder: (context, state) =>
          SalonVerifyOtpScreen(email: state.extra as String),
    ),
    GoRoute(
      path: AppRoutes.salonRegisterSuccess,
      builder: (context, state) => const SalonRegisterSuccessScreen(),
    ),
    GoRoute(
      path: AppRoutes.bookAppointment,
      builder: (context, state) =>
          BookAppointmentScreen(args: state.extra as BookAppointmentArgs),
    ),
  ],
);
