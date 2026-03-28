import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:diko_barber/core/cache/secure_storage_cache_client.dart';
import 'package:diko_barber/core/cache/shared_pref_cache_client.dart';
import 'package:diko_barber/core/locale/data/locale_repository_impl.dart';
import 'package:diko_barber/core/locale/domain/locale_repository.dart';
import 'package:diko_barber/core/locale/domain/use_cases/get_locale_use_case.dart';
import 'package:diko_barber/core/locale/domain/use_cases/save_locale_use_case.dart';
import 'package:diko_barber/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:diko_barber/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:diko_barber/features/onboarding/domain/use_cases/check_onboarding_use_case.dart';
import 'package:diko_barber/features/onboarding/domain/use_cases/complete_onboarding_use_case.dart';
import 'package:diko_barber/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:diko_barber/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:diko_barber/features/auth/domain/repositories/auth_repository.dart';
import 'package:diko_barber/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:diko_barber/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:diko_barber/features/auth/domain/use_cases/verify_otp_use_case.dart';
import 'package:diko_barber/features/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:diko_barber/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:diko_barber/features/auth/presentation/cubit/verify_otp_cubit.dart';
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
  sl.registerLazySingleton<LocaleRepository>(
    () => LocaleRepositoryImpl(sl<SharedPrefCacheClient>()),
  );
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(sl<SharedPrefCacheClient>()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(),
  );

  // ─── Use Cases ────────────────────────────────────────────────────────────
  sl.registerLazySingleton<GetLocaleUseCase>(
    () => GetLocaleUseCase(sl<LocaleRepository>()),
  );
  sl.registerLazySingleton<SaveLocaleUseCase>(
    () => SaveLocaleUseCase(sl<LocaleRepository>()),
  );
  sl.registerLazySingleton<CheckOnboardingUseCase>(
    () => CheckOnboardingUseCase(sl<OnboardingRepository>()),
  );
  sl.registerLazySingleton<CompleteOnboardingUseCase>(
    () => CompleteOnboardingUseCase(sl<OnboardingRepository>()),
  );
  sl.registerLazySingleton<CompleteSplashUseCase>(
    () => CompleteSplashUseCase(sl<OnboardingRepository>()),
  );
  sl.registerLazySingleton<SignInUseCase>(
    () => SignInUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(sl<AuthRepository>()),
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
  sl.registerFactory<SignInCubit>(
    () => SignInCubit(signInUseCase: sl<SignInUseCase>()),
  );
  sl.registerFactory<SignUpCubit>(
    () => SignUpCubit(signUpUseCase: sl<SignUpUseCase>()),
  );
  sl.registerFactoryParam<VerifyOtpCubit, String, void>(
    (email, _) => VerifyOtpCubit(
      verifyOtpUseCase: sl<VerifyOtpUseCase>(),
      email: email,
    ),
  );
}
