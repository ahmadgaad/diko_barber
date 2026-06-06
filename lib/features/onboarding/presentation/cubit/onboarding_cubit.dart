import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ronaq_barber/core/router/app_routes.dart';
import 'package:ronaq_barber/features/onboarding/domain/use_cases/complete_onboarding_use_case.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({required CompleteOnboardingUseCase completeOnboardingUseCase})
      : _completeOnboardingUseCase = completeOnboardingUseCase,
        super(const OnboardingInitial());

  final CompleteOnboardingUseCase _completeOnboardingUseCase;

  int currentPage = 0;

  void onPageChanged(int page) => currentPage = page;

  void onNext(int totalPages) {
    if (currentPage < totalPages - 1) {
      currentPage++;
      emit(OnboardingPageChanged(page: currentPage));
    }
  }

  Future<void> skip() async {
    await _completeOnboardingUseCase();
    emit(const OnboardingNavigate(target: AppRoutes.login));
  }

  Future<void> signIn() async {
    await _completeOnboardingUseCase();
    emit(const OnboardingNavigate(target: AppRoutes.login));
  }

  Future<void> signUp() async {
    await _completeOnboardingUseCase();
    emit(const OnboardingNavigate(target: AppRoutes.signup));
  }
}
