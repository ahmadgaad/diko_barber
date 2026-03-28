sealed class OnboardingState {
  const OnboardingState();
}

final class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

final class OnboardingNavigate extends OnboardingState {
  const OnboardingNavigate({required this.target});

  final String target;
}
