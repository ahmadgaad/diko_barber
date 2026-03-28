import '../repositories/onboarding_repository.dart';

class CheckOnboardingUseCase {
  const CheckOnboardingUseCase(this._repository);

  final OnboardingRepository _repository;

  Future<bool> call() => _repository.hasSeenOnboarding();
}
