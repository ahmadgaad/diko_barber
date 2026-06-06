import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ronaq_barber/features/splash/domain/use_cases/complete_splash_use_case.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({required CompleteSplashUseCase completeSplashUseCase})
      : _completeSplashUseCase = completeSplashUseCase,
        super(const SplashInitial());

  final CompleteSplashUseCase _completeSplashUseCase;

  void startAnimation() => emit(const SplashAnimating());

  Future<void> onAnimationComplete() async {
    final target = await _completeSplashUseCase();
    emit(SplashComplete(navigationTarget: target));
  }
}
