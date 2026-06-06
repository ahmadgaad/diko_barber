import 'package:ronaq_barber/core/router/app_routes.dart';
import 'package:ronaq_barber/features/onboarding/domain/repositories/onboarding_repository.dart';

class CompleteSplashUseCase {
  const CompleteSplashUseCase(this._onboardingRepository);

  final OnboardingRepository _onboardingRepository;

  Future<String> call() async {
    final seen = await _onboardingRepository.hasSeenOnboarding();
    return seen ? AppRoutes.login : AppRoutes.onboarding;
  }
}
