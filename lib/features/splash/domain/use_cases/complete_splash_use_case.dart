import 'package:diko_barber/core/router/app_routes.dart';

class CompleteSplashUseCase {
  const CompleteSplashUseCase();

  /// Returns the navigation target after the splash animation completes.
  /// This is the hook point for future auth/onboarding routing logic.
  String call() => AppRoutes.home;
}
