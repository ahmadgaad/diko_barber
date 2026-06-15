import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/core/router/app_routes.dart';
import 'package:zain/core/services/user_session.dart';
import 'package:zain/features/onboarding/domain/use_cases/complete_onboarding_use_case.dart';
import 'package:zain/features/onboarding/domain/use_cases/get_onboarding_use_case.dart';

import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({
    required CompleteOnboardingUseCase completeOnboardingUseCase,
    required GetOnboardingUseCase getOnboardingUseCase,
    required UserSession userSession,
  })  : _completeOnboardingUseCase = completeOnboardingUseCase,
        _getOnboardingUseCase = getOnboardingUseCase,
        _userSession = userSession,
        super(const OnboardingLoading()) {
    _loadItems();
  }

  final CompleteOnboardingUseCase _completeOnboardingUseCase;
  final GetOnboardingUseCase _getOnboardingUseCase;
  final UserSession _userSession;

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

  Future<void> continueAsGuest() async {
    await _completeOnboardingUseCase();
    await _userSession.continueAsGuest();
    emit(const OnboardingNavigate(target: AppRoutes.home));
  }
}
