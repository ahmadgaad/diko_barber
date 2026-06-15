import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/core/router/app_routes.dart';
import 'package:zain/features/onboarding/domain/use_cases/get_onboarding_use_case.dart';
import 'package:zain/features/splash/domain/use_cases/complete_splash_use_case.dart';

import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({
    required CompleteSplashUseCase completeSplashUseCase,
    required GetOnboardingUseCase getOnboardingUseCase,
  })  : _completeSplashUseCase = completeSplashUseCase,
        _getOnboardingUseCase = getOnboardingUseCase,
        super(const SplashInitial());

  final CompleteSplashUseCase _completeSplashUseCase;
  final GetOnboardingUseCase _getOnboardingUseCase;

  void startAnimation() => emit(const SplashAnimating());

  Future<void> onAnimationComplete() async {
    final target = await _completeSplashUseCase();

    var imageUrls = <String>[];

    if (target == AppRoutes.onboarding) {
      final result = await _getOnboardingUseCase();
      if (result case Success(:final data)) {
        imageUrls = data.map((e) => e.imageUrl).toList();
      }
    }

    emit(SplashComplete(navigationTarget: target, imagesToPrecache: imageUrls));
  }
}
