import 'package:get_it/get_it.dart';

import 'package:diko_barber/features/splash/domain/use_cases/complete_splash_use_case.dart';
import 'package:diko_barber/features/splash/presentation/cubit/splash_cubit.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  // ─── Use Cases ────────────────────────────────────────────────────────────
  sl.registerLazySingleton<CompleteSplashUseCase>(
    () => const CompleteSplashUseCase(),
  );

  // ─── Cubits ───────────────────────────────────────────────────────────────
  sl.registerFactory<SplashCubit>(
    () => SplashCubit(completeSplashUseCase: sl<CompleteSplashUseCase>()),
  );
}
