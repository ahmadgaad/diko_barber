import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:diko_barber/core/cache/secure_storage_cache_client.dart';
import 'package:diko_barber/core/cache/shared_pref_cache_client.dart';
import 'package:diko_barber/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:diko_barber/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:diko_barber/features/onboarding/domain/use_cases/check_onboarding_use_case.dart';
import 'package:diko_barber/features/onboarding/domain/use_cases/complete_onboarding_use_case.dart';
import 'package:diko_barber/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:diko_barber/features/splash/domain/use_cases/complete_splash_use_case.dart';
import 'package:diko_barber/features/splash/presentation/cubit/splash_cubit.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ─── External ─────────────────────────────────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // ─── Cache ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<SharedPrefCacheClient>(
    () => SharedPrefCacheClient(sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<SecureStorageCacheClient>(
    () => SecureStorageCacheClient(sl<FlutterSecureStorage>()),
  );

  // ─── Repositories ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(sl<SharedPrefCacheClient>()),
  );

  // ─── Use Cases ────────────────────────────────────────────────────────────
  sl.registerLazySingleton<CheckOnboardingUseCase>(
    () => CheckOnboardingUseCase(sl<OnboardingRepository>()),
  );
  sl.registerLazySingleton<CompleteOnboardingUseCase>(
    () => CompleteOnboardingUseCase(sl<OnboardingRepository>()),
  );
  sl.registerLazySingleton<CompleteSplashUseCase>(
    () => CompleteSplashUseCase(sl<OnboardingRepository>()),
  );

  // ─── Cubits ───────────────────────────────────────────────────────────────
  sl.registerFactory<OnboardingCubit>(
    () => OnboardingCubit(
      completeOnboardingUseCase: sl<CompleteOnboardingUseCase>(),
    ),
  );
  sl.registerFactory<SplashCubit>(
    () => SplashCubit(completeSplashUseCase: sl<CompleteSplashUseCase>()),
  );
}
