sealed class OnboardingState {
  const OnboardingState();
}

final class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

final class OnboardingPageChanged extends OnboardingState {
  const OnboardingPageChanged({required this.page});

  final int page;
}

final class OnboardingNavigate extends OnboardingState {
  const OnboardingNavigate({required this.target});

  final String target;
}
