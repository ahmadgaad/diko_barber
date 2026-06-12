import 'package:ronaq_barber/features/onboarding/domain/entities/onboarding_item.dart';

sealed class OnboardingState {
  const OnboardingState();
}

final class OnboardingLoading extends OnboardingState {
  const OnboardingLoading();
}

final class OnboardingLoaded extends OnboardingState {
  const OnboardingLoaded({required this.items, this.currentPage = 0});

  final List<OnboardingItem> items;
  final int currentPage;

  OnboardingLoaded copyWith({int? currentPage}) => OnboardingLoaded(
        items: items,
        currentPage: currentPage ?? this.currentPage,
      );
}

final class OnboardingError extends OnboardingState {
  const OnboardingError({required this.message});

  final String message;
}

final class OnboardingNavigate extends OnboardingState {
  const OnboardingNavigate({required this.target});

  final String target;
}
