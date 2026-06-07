import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/core/router/app_routes.dart';
import 'package:ronaq_barber/features/onboarding/domain/use_cases/complete_onboarding_use_case.dart';
import 'package:ronaq_barber/features/onboarding/domain/use_cases/get_onboarding_use_case.dart';

import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({
    required CompleteOnboardingUseCase completeOnboardingUseCase,
    required GetOnboardingUseCase getOnboardingUseCase,
  })  : _completeOnboardingUseCase = completeOnboardingUseCase,
        _getOnboardingUseCase = getOnboardingUseCase,
        super(const OnboardingLoading()) {
    _loadItems();
  }

  final CompleteOnboardingUseCase _completeOnboardingUseCase;
  final GetOnboardingUseCase _getOnboardingUseCase;

  OnboardingLoaded get _loaded => state as OnboardingLoaded;

  Future<void> _loadItems() async {
    emit(const OnboardingLoading());
    final result = await _getOnboardingUseCase();
    switch (result) {
      case Success(:final data):
        emit(OnboardingLoaded(items: data));
      case Failure(:final error):
        emit(OnboardingError(message: error.message));
    }
  }

  Future<void> retry() => _loadItems();

  void onPageChanged(int page) {
    if (state is! OnboardingLoaded) return;
    if (_loaded.currentPage == page) return;
    emit(_loaded.copyWith(currentPage: page));
  }

  void onNext() {
    if (state is! OnboardingLoaded) return;
    final next = _loaded.currentPage + 1;
    if (next < _loaded.items.length) {
      emit(_loaded.copyWith(currentPage: next));
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
