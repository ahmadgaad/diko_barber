import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zain/core/di/service_locator.dart';
import 'package:zain/core/observers/app_router_observer.dart';
import 'package:zain/core/widgets/app_shell.dart';
import 'package:zain/features/book_appointment/presentation/book_appointment_args.dart';
import 'package:zain/features/book_appointment/presentation/screens/book_appointment_screen.dart';
import 'package:zain/features/booking_schedule/domain/entities/created_appointment.dart';
import 'package:zain/features/checkout/presentation/screens/checkout_screen.dart';
import 'package:zain/features/booking/presentation/cubit/bookings_cubit.dart';
import 'package:zain/features/booking/presentation/screens/booking_view.dart';
import 'package:zain/features/booking_schedule/presentation/booking_schedule_args.dart';
import 'package:zain/features/booking_schedule/presentation/screens/booking_schedule_screen.dart';
import 'package:zain/features/claim_coupon/presentation/claim_coupon_args.dart';
import 'package:zain/features/claim_coupon/presentation/screens/claim_coupon_screen.dart';
import 'package:zain/features/explore/presentation/cubit/explore_cubit.dart';
import 'package:zain/features/explore/presentation/screens/explore_map_screen.dart';
import 'package:zain/features/explore/presentation/screens/explore_view.dart';
import 'package:zain/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:zain/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:zain/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:zain/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:zain/features/auth/presentation/screens/verify_otp_screen.dart';
import 'package:zain/features/auth/presentation/screens/verify_reset_password_screen.dart';
import 'package:zain/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:zain/features/favorites/presentation/screens/favorites_view.dart';
import 'package:zain/features/home/presentation/screens/home_screen.dart';
import 'package:zain/features/packages/presentation/cubit/package_details_cubit.dart';
import 'package:zain/features/packages/presentation/cubit/packages_list_cubit.dart';
import 'package:zain/features/packages/presentation/screens/package_details_screen.dart';
import 'package:zain/features/packages/presentation/screens/packages_list_screen.dart';
import 'package:zain/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:zain/features/profile/presentation/screens/profile_view.dart';
import 'package:zain/features/salon_auth/presentation/screens/salon_register_screen.dart';
import 'package:zain/features/salon_auth/presentation/screens/salon_register_success_screen.dart';
import 'package:zain/features/salon_auth/presentation/screens/salon_verify_otp_screen.dart';
import 'package:zain/features/salon_details/presentation/cubit/salon_details_cubit.dart';
import 'package:zain/features/salon_details/presentation/screens/salon_details_args.dart';
import 'package:zain/features/salon_details/presentation/screens/salon_details_screen.dart';
import 'package:zain/features/search/presentation/screens/search_screen.dart';
import 'package:zain/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:zain/features/splash/presentation/screens/splash_screen.dart';

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

    // ── Shell (bottom nav) ────────────────────────────────────────────────────
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<ExploreCubit>()),
          BlocProvider(create: (_) => sl<BookingsCubit>()),
          BlocProvider(create: (_) => sl<FavoritesCubit>()),
          BlocProvider(create: (_) => sl<ProfileCubit>()),
        ],
        child: AppShell(navigationShell: navigationShell),
      ),
      branches: [
        // 0 — Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // 1 — Explore
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.explore,
              builder: (context, state) => const ExploreView(),
            ),
          ],
        ),
        // 2 — Bookings
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.bookings,
              builder: (context, state) => const BookingView(),
            ),
          ],
        ),
        // 3 — Favorites
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.favorites,
              builder: (context, state) => const FavoritesView(),
            ),
          ],
        ),
        // 4 — Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfileView(),
            ),
          ],
        ),
      ],
    ),

    // ── Full-screen routes (outside shell) ────────────────────────────────────
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
      builder: (context, state) {
        final salonId = int.parse(state.pathParameters['id']!);
        final args = state.extra as SalonDetailsArgs?;
        return BlocProvider(
          create: (_) => sl<SalonDetailsCubit>()
            ..load(salonId, couponCode: args?.couponCode),
          child: SalonDetailsScreen(initialTab: args?.initialTab ?? 0),
        );
      },
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
    GoRoute(
      path: AppRoutes.claimCoupon,
      builder: (context, state) =>
          ClaimCouponScreen(args: state.extra as ClaimCouponArgs),
    ),
    GoRoute(
      path: AppRoutes.bookingSchedule,
      builder: (context, state) =>
          BookingScheduleScreen(args: state.extra as BookingScheduleArgs),
    ),
    GoRoute(
      path: AppRoutes.checkout,
      builder: (context, state) =>
          CheckoutScreen(appointment: state.extra as CreatedAppointment),
    ),
    GoRoute(
      path: AppRoutes.packageDetails,
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return BlocProvider(
          create: (_) => sl<PackageDetailsCubit>()..load(id),
          child: const PackageDetailsScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.packagesList,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<PackagesListCubit>(),
        child: const PackagesListScreen(),
      ),
    ),
  ],
);
