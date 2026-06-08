import 'package:ronaq_barber/core/networking/api_consumer.dart';
import 'package:ronaq_barber/core/networking/dio_consumer.dart';
import 'package:ronaq_barber/core/networking/interceptors/authorization_interceptor.dart';
import 'package:ronaq_barber/core/networking/network_info.dart';
import 'package:ronaq_barber/core/shared/data/data_sources/shared_remote_data_source.dart';
import 'package:ronaq_barber/core/shared/data/repositories/shared_repository_impl.dart';
import 'package:ronaq_barber/core/shared/domain/repositories/shared_repository.dart';
import 'package:ronaq_barber/core/shared/domain/use_cases/get_categories_use_case.dart';
import 'package:ronaq_barber/core/shared/domain/use_cases/get_cities_use_case.dart';
import 'package:ronaq_barber/core/shared/domain/use_cases/get_neighborhoods_use_case.dart';
import 'package:ronaq_barber/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:ronaq_barber/features/salon_auth/data/data_sources/salon_auth_remote_data_source.dart';
import 'package:ronaq_barber/features/salon_auth/data/repositories/salon_auth_repository_impl.dart';
import 'package:ronaq_barber/features/salon_auth/domain/repositories/salon_auth_repository.dart';
import 'package:ronaq_barber/features/salon_auth/domain/use_cases/salon_register_use_case.dart';
import 'package:ronaq_barber/features/salon_auth/domain/use_cases/salon_resend_otp_use_case.dart';
import 'package:ronaq_barber/features/salon_auth/domain/use_cases/salon_verify_otp_use_case.dart';
import 'package:ronaq_barber/features/salon_auth/presentation/cubit/salon_register_cubit.dart';
import 'package:ronaq_barber/features/salon_auth/presentation/cubit/salon_verify_otp_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ronaq_barber/core/cache/secure_storage_cache_client.dart';
import 'package:ronaq_barber/core/cache/shared_pref_cache_client.dart';
import 'package:ronaq_barber/core/locale/data/locale_repository_impl.dart';
import 'package:ronaq_barber/core/locale/domain/locale_repository.dart';
import 'package:ronaq_barber/core/locale/domain/use_cases/get_locale_use_case.dart';
import 'package:ronaq_barber/core/locale/domain/use_cases/save_locale_use_case.dart';
import 'package:ronaq_barber/features/onboarding/data/data_sources/onboarding_local_data_source.dart';
import 'package:ronaq_barber/features/onboarding/data/data_sources/onboarding_remote_data_source.dart';
import 'package:ronaq_barber/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:ronaq_barber/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:ronaq_barber/features/onboarding/domain/use_cases/check_onboarding_use_case.dart';
import 'package:ronaq_barber/features/onboarding/domain/use_cases/complete_onboarding_use_case.dart';
import 'package:ronaq_barber/features/onboarding/domain/use_cases/get_onboarding_use_case.dart';
import 'package:ronaq_barber/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:ronaq_barber/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ronaq_barber/features/auth/domain/repositories/auth_repository.dart';
import 'package:ronaq_barber/features/auth/domain/use_cases/forgot_password_use_case.dart';
import 'package:ronaq_barber/features/auth/domain/use_cases/reset_password_use_case.dart';
import 'package:ronaq_barber/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:ronaq_barber/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:ronaq_barber/features/auth/domain/use_cases/resend_verification_use_case.dart';
import 'package:ronaq_barber/features/auth/domain/use_cases/social_login_use_case.dart';
import 'package:ronaq_barber/features/auth/domain/use_cases/verify_otp_use_case.dart';
import 'package:ronaq_barber/features/auth/domain/use_cases/verify_reset_password_use_case.dart';
import 'package:ronaq_barber/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:ronaq_barber/features/auth/presentation/cubit/reset_password_cubit.dart';
import 'package:ronaq_barber/features/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:ronaq_barber/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:ronaq_barber/features/auth/presentation/cubit/verify_otp_cubit.dart';
import 'package:ronaq_barber/features/auth/presentation/cubit/verify_reset_password_cubit.dart';
import 'package:ronaq_barber/features/splash/domain/use_cases/complete_splash_use_case.dart';
import 'package:ronaq_barber/features/splash/presentation/cubit/splash_cubit.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ─── External ─────────────────────────────────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  sl.registerLazySingleton<InternetConnection>(() => InternetConnection());
  sl.registerLazySingleton<INetworkInfo>(
    () => NetworkInfo(sl<InternetConnection>()),
  );
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<AuthorizationInterceptor>(
    () => AuthorizationInterceptor(),
  );
  sl.registerLazySingleton<INetworkService>(
    () => DioConsumer(
      dioClient: sl<Dio>(),
      authInterceptor: sl<AuthorizationInterceptor>(),
      prefs: sl<SharedPreferences>(),
    ),
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
  sl.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(sl<SharedPrefCacheClient>()),
  );
  sl.registerLazySingleton<OnboardingRemoteDataSource>(
    () => OnboardingRemoteDataSourceImpl(sl<INetworkService>()),
  );
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(
      cache: sl<SharedPrefCacheClient>(),
      remoteDataSource: sl<OnboardingRemoteDataSource>(),
      localDataSource: sl<OnboardingLocalDataSource>(),
    ),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<INetworkService>()),
  );
  sl.registerLazySingleton<SharedRemoteDataSource>(
    () => SharedRemoteDataSourceImpl(sl<INetworkService>()),
  );
  sl.registerLazySingleton<SharedRepository>(
    () => SharedRepositoryImpl(sl<SharedRemoteDataSource>()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );
  sl.registerLazySingleton<SalonAuthRemoteDataSource>(
    () => SalonAuthRemoteDataSourceImpl(sl<INetworkService>()),
  );
  sl.registerLazySingleton<SalonAuthRepository>(
    () => SalonAuthRepositoryImpl(sl<SalonAuthRemoteDataSource>()),
  );

  // ─── Use Cases ────────────────────────────────────────────────────────────
  sl.registerLazySingleton<GetCitiesUseCase>(
    () => GetCitiesUseCase(sl<SharedRepository>()),
  );
  sl.registerLazySingleton<GetNeighborhoodsUseCase>(
    () => GetNeighborhoodsUseCase(sl<SharedRepository>()),
  );
  sl.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(sl<SharedRepository>()),
  );
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
  sl.registerLazySingleton<GetOnboardingUseCase>(
    () => GetOnboardingUseCase(sl<OnboardingRepository>()),
  );
  sl.registerLazySingleton<CompleteSplashUseCase>(
    () => CompleteSplashUseCase(sl<OnboardingRepository>(), sl<SecureStorageCacheClient>()),
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
  sl.registerLazySingleton<ResendVerificationUseCase>(
    () => ResendVerificationUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SocialLoginUseCase>(
    () => SocialLoginUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<ForgotPasswordUseCase>(
    () => ForgotPasswordUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<VerifyResetPasswordUseCase>(
    () => VerifyResetPasswordUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SalonRegisterUseCase>(
    () => SalonRegisterUseCase(sl<SalonAuthRepository>()),
  );
  sl.registerLazySingleton<SalonVerifyOtpUseCase>(
    () => SalonVerifyOtpUseCase(sl<SalonAuthRepository>()),
  );
  sl.registerLazySingleton<SalonResendOtpUseCase>(
    () => SalonResendOtpUseCase(sl<SalonAuthRepository>()),
  );

  // ─── Cubits ───────────────────────────────────────────────────────────────
  sl.registerFactory<OnboardingCubit>(
    () => OnboardingCubit(
      completeOnboardingUseCase: sl<CompleteOnboardingUseCase>(),
      getOnboardingUseCase: sl<GetOnboardingUseCase>(),
    ),
  );
  sl.registerFactory<SplashCubit>(
    () => SplashCubit(
      completeSplashUseCase: sl<CompleteSplashUseCase>(),
      getOnboardingUseCase: sl<GetOnboardingUseCase>(),
    ),
  );
  sl.registerFactory<SignInCubit>(
    () => SignInCubit(
      signInUseCase: sl<SignInUseCase>(),
      socialLoginUseCase: sl<SocialLoginUseCase>(),
      secureStorage: sl<SecureStorageCacheClient>(),
    ),
  );
  sl.registerFactory<SignUpCubit>(
    () => SignUpCubit(
      signUpUseCase: sl<SignUpUseCase>(),
      getCitiesUseCase: sl<GetCitiesUseCase>(),
      getNeighborhoodsUseCase: sl<GetNeighborhoodsUseCase>(),
      secureStorage: sl<SecureStorageCacheClient>(),
      socialLoginUseCase: sl<SocialLoginUseCase>(),
    ),
  );
  sl.registerFactoryParam<VerifyOtpCubit, String, void>(
    (email, _) => VerifyOtpCubit(
      verifyOtpUseCase: sl<VerifyOtpUseCase>(),
      resendVerificationUseCase: sl<ResendVerificationUseCase>(),
      secureStorage: sl<SecureStorageCacheClient>(),
      email: email,
    ),
  );
  sl.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(sl<ForgotPasswordUseCase>()),
  );
  sl.registerFactoryParam<VerifyResetPasswordCubit, String, void>(
    (email, _) => VerifyResetPasswordCubit(
      verifyResetPasswordUseCase: sl<VerifyResetPasswordUseCase>(),
      secureStorage: sl<SecureStorageCacheClient>(),
      email: email,
    ),
  );
  sl.registerFactory<ResetPasswordCubit>(
    () => ResetPasswordCubit(sl<ResetPasswordUseCase>()),
  );
  sl.registerFactory<SalonRegisterCubit>(
    () => SalonRegisterCubit(
      salonRegisterUseCase: sl<SalonRegisterUseCase>(),
      getCitiesUseCase: sl<GetCitiesUseCase>(),
      getNeighborhoodsUseCase: sl<GetNeighborhoodsUseCase>(),
      getCategoriesUseCase: sl<GetCategoriesUseCase>(),
    ),
  );
  sl.registerFactoryParam<SalonVerifyOtpCubit, String, void>(
    (email, _) => SalonVerifyOtpCubit(
      verifyOtpUseCase: sl<SalonVerifyOtpUseCase>(),
      resendOtpUseCase: sl<SalonResendOtpUseCase>(),
      email: email,
    ),
  );
}
