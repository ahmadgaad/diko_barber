import 'package:zain/core/location_picker/data/data_sources/location_picker_remote_data_source.dart';
import 'package:zain/core/location_picker/data/repositories/location_picker_repository_impl.dart';
import 'package:zain/core/location_picker/domain/repositories/location_picker_repository.dart';
import 'package:zain/core/location_picker/domain/use_cases/fetch_suggestions_use_case.dart';
import 'package:zain/core/location_picker/domain/use_cases/geocode_by_place_id_use_case.dart';
import 'package:zain/core/location_picker/domain/use_cases/reverse_geocode_use_case.dart';
import 'package:zain/core/location_picker/presentation/cubit/location_picker_cubit.dart';
import 'package:zain/core/networking/api_consumer.dart';
import 'package:zain/core/services/location_service.dart';
import 'package:zain/core/services/user_session.dart';
import 'package:zain/core/networking/dio_consumer.dart';
import 'package:zain/core/networking/interceptors/authorization_interceptor.dart';
import 'package:zain/core/networking/network_info.dart';
import 'package:zain/core/shared/data/data_sources/shared_remote_data_source.dart';
import 'package:zain/core/shared/data/repositories/shared_repository_impl.dart';
import 'package:zain/core/shared/domain/repositories/shared_repository.dart';
import 'package:zain/core/shared/domain/use_cases/get_banners_use_case.dart';
import 'package:zain/core/shared/domain/use_cases/get_categories_use_case.dart';
import 'package:zain/core/shared/domain/use_cases/get_nearest_coupons_use_case.dart';
import 'package:zain/core/shared/domain/use_cases/get_nearest_packages_use_case.dart';
import 'package:zain/core/shared/domain/use_cases/get_nearest_salons_use_case.dart';
import 'package:zain/core/shared/domain/use_cases/get_nearest_services_use_case.dart';
import 'package:zain/features/home/presentation/cubit/categories_cubit.dart';
import 'package:zain/core/shared/domain/use_cases/get_cities_use_case.dart';
import 'package:zain/core/shared/domain/use_cases/get_neighborhoods_use_case.dart';
import 'package:zain/features/home/presentation/cubit/banners_cubit.dart';
import 'package:zain/features/home/presentation/cubit/coupons_cubit.dart';
import 'package:zain/features/home/presentation/cubit/featured_packages_cubit.dart';
import 'package:zain/features/home/presentation/cubit/featured_services_cubit.dart';
import 'package:zain/features/home/presentation/cubit/home_cubit.dart';
import 'package:zain/features/home/presentation/cubit/salons_cubit.dart';
import 'package:zain/features/explore/presentation/cubit/explore_cubit.dart';
import 'package:zain/features/search/presentation/cubit/search_cubit.dart';
import 'package:zain/features/booking/data/data_sources/bookings_remote_data_source.dart';
import 'package:zain/features/booking/data/repositories/bookings_repository_impl.dart';
import 'package:zain/features/booking/domain/repositories/bookings_repository.dart';
import 'package:zain/features/booking/domain/use_cases/cancel_appointment_use_case.dart';
import 'package:zain/features/booking/domain/use_cases/get_appointment_statuses_use_case.dart';
import 'package:zain/features/booking/domain/use_cases/get_appointments_use_case.dart';
import 'package:zain/features/booking/presentation/cubit/bookings_cubit.dart';
import 'package:zain/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:zain/core/theme/cubit/theme_cubit.dart';
import 'package:zain/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:zain/features/packages/data/data_sources/packages_remote_data_source.dart';
import 'package:zain/features/packages/data/repositories/packages_repository_impl.dart';
import 'package:zain/features/packages/domain/repositories/packages_repository.dart';
import 'package:zain/features/packages/domain/use_cases/get_packages_use_case.dart';
import 'package:zain/features/packages/domain/use_cases/get_package_details_use_case.dart';
import 'package:zain/features/salon_details/data/data_sources/salon_details_remote_data_source.dart';
import 'package:zain/features/salon_details/data/repositories/salon_details_repository_impl.dart';
import 'package:zain/features/salon_details/domain/repositories/salon_details_repository.dart';
import 'package:zain/features/salon_details/domain/use_cases/get_salon_details_use_case.dart';
import 'package:zain/features/salon_details/domain/use_cases/get_salon_gallery_use_case.dart';
import 'package:zain/features/salon_details/domain/use_cases/get_salon_ratings_use_case.dart';
import 'package:zain/features/salon_details/presentation/cubit/salon_gallery_cubit.dart';
import 'package:zain/features/salon_details/presentation/cubit/salon_ratings_cubit.dart';
import 'package:zain/core/shared/domain/use_cases/get_favorites_use_case.dart';
import 'package:zain/core/shared/domain/use_cases/toggle_favorite_use_case.dart';
import 'package:zain/features/packages/presentation/cubit/package_details_cubit.dart';
import 'package:zain/features/packages/presentation/cubit/packages_list_cubit.dart';
import 'package:zain/features/salon_details/presentation/cubit/salon_details_cubit.dart';
import 'package:zain/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:zain/features/salon_auth/data/data_sources/salon_auth_remote_data_source.dart';
import 'package:zain/features/salon_auth/data/repositories/salon_auth_repository_impl.dart';
import 'package:zain/features/salon_auth/domain/repositories/salon_auth_repository.dart';
import 'package:zain/features/salon_auth/domain/use_cases/salon_register_use_case.dart';
import 'package:zain/features/salon_auth/domain/use_cases/salon_resend_otp_use_case.dart';
import 'package:zain/features/salon_auth/domain/use_cases/salon_verify_otp_use_case.dart';
import 'package:zain/features/salon_auth/presentation/cubit/salon_register_cubit.dart';
import 'package:zain/features/salon_auth/presentation/cubit/salon_verify_otp_cubit.dart';
import 'package:zain/features/claim_coupon/data/data_sources/claim_coupon_remote_data_source.dart';
import 'package:zain/features/claim_coupon/data/repositories/claim_coupon_repository_impl.dart';
import 'package:zain/features/claim_coupon/domain/repositories/claim_coupon_repository.dart';
import 'package:zain/features/claim_coupon/domain/use_cases/get_available_barbers_use_case.dart';
import 'package:zain/features/claim_coupon/domain/use_cases/get_available_slots_use_case.dart';
import 'package:zain/features/claim_coupon/domain/use_cases/get_coupon_eligible_items_use_case.dart';
import 'package:zain/features/claim_coupon/presentation/cubit/claim_coupon_cubit.dart';
import 'package:zain/features/checkout/data/data_sources/checkout_remote_data_source.dart';
import 'package:zain/features/checkout/data/repositories/checkout_repository_impl.dart';
import 'package:zain/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:zain/features/checkout/domain/use_cases/get_payment_methods_use_case.dart';
import 'package:zain/features/checkout/domain/use_cases/pay_appointment_use_case.dart';
import 'package:zain/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:zain/features/booking_schedule/data/data_sources/booking_schedule_remote_data_source.dart';
import 'package:zain/features/booking_schedule/data/repositories/booking_schedule_repository_impl.dart';
import 'package:zain/features/booking_schedule/domain/repositories/booking_schedule_repository.dart';
import 'package:zain/features/booking_schedule/domain/use_cases/create_appointment_use_case.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zain/core/cache/secure_storage_cache_client.dart';
import 'package:zain/core/cache/shared_pref_cache_client.dart';
import 'package:zain/core/locale/data/locale_repository_impl.dart';
import 'package:zain/core/locale/domain/locale_repository.dart';
import 'package:zain/core/locale/domain/use_cases/get_locale_use_case.dart';
import 'package:zain/core/locale/domain/use_cases/save_locale_use_case.dart';
import 'package:zain/features/onboarding/data/data_sources/onboarding_local_data_source.dart';
import 'package:zain/features/onboarding/data/data_sources/onboarding_remote_data_source.dart';
import 'package:zain/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:zain/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:zain/features/onboarding/domain/use_cases/check_onboarding_use_case.dart';
import 'package:zain/features/onboarding/domain/use_cases/complete_onboarding_use_case.dart';
import 'package:zain/features/onboarding/domain/use_cases/get_onboarding_use_case.dart';
import 'package:zain/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:zain/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:zain/features/auth/domain/repositories/auth_repository.dart';
import 'package:zain/features/auth/domain/use_cases/forgot_password_use_case.dart';
import 'package:zain/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:zain/features/auth/domain/use_cases/update_location_use_case.dart';
import 'package:zain/features/auth/domain/use_cases/reset_password_use_case.dart';
import 'package:zain/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:zain/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:zain/features/auth/domain/use_cases/resend_verification_use_case.dart';
import 'package:zain/features/auth/domain/use_cases/social_login_use_case.dart';
import 'package:zain/features/auth/domain/use_cases/verify_otp_use_case.dart';
import 'package:zain/features/auth/domain/use_cases/verify_reset_password_use_case.dart';
import 'package:zain/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:zain/features/auth/presentation/cubit/reset_password_cubit.dart';
import 'package:zain/features/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:zain/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:zain/features/auth/presentation/cubit/verify_otp_cubit.dart';
import 'package:zain/features/auth/presentation/cubit/verify_reset_password_cubit.dart';
import 'package:zain/features/book_appointment/data/data_sources/book_appointment_remote_data_source.dart';
import 'package:zain/features/book_appointment/data/repositories/book_appointment_repository_impl.dart';
import 'package:zain/features/book_appointment/domain/repositories/book_appointment_repository.dart';
import 'package:zain/features/book_appointment/domain/use_cases/create_booking_use_case.dart';
import 'package:zain/features/book_appointment/domain/use_cases/get_salon_services_use_case.dart';
import 'package:zain/features/book_appointment/domain/use_cases/get_staff_use_case.dart';
import 'package:zain/features/book_appointment/domain/use_cases/get_time_slots_use_case.dart';
import 'package:zain/features/book_appointment/domain/use_cases/validate_coupon_use_case.dart';
import 'package:zain/features/book_appointment/presentation/cubit/book_appointment_cubit.dart';
import 'package:zain/features/splash/domain/use_cases/complete_splash_use_case.dart';
import 'package:zain/features/splash/presentation/cubit/splash_cubit.dart';

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
  sl.registerLazySingleton<LocationService>(LocationService.new);
  sl.registerLazySingleton<UserSession>(
    () => UserSession(sl<SecureStorageCacheClient>()),
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

  // ─── Location Picker ───────────────────────────────────────────────────────
  sl.registerLazySingleton<LocationPickerRemoteDataSource>(
    () => LocationPickerRemoteDataSourceImpl(Dio()),
  );
  sl.registerLazySingleton<LocationPickerRepository>(
    () => LocationPickerRepositoryImpl(
      sl<LocationPickerRemoteDataSource>(),
      sl<SharedPreferences>(),
    ),
  );
  sl.registerLazySingleton<ReverseGeocodeUseCase>(
    () => ReverseGeocodeUseCase(sl<LocationPickerRepository>()),
  );
  sl.registerLazySingleton<FetchSuggestionsUseCase>(
    () => FetchSuggestionsUseCase(sl<LocationPickerRepository>()),
  );
  sl.registerLazySingleton<GeocodeByPlaceIdUseCase>(
    () => GeocodeByPlaceIdUseCase(sl<LocationPickerRepository>()),
  );
  sl.registerFactory<LocationPickerCubit>(
    () => LocationPickerCubit(
      reverseGeocodeUseCase: sl<ReverseGeocodeUseCase>(),
      fetchSuggestionsUseCase: sl<FetchSuggestionsUseCase>(),
      geocodeByPlaceIdUseCase: sl<GeocodeByPlaceIdUseCase>(),
      locationService: sl<LocationService>(),
    ),
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
  sl.registerLazySingleton<SalonDetailsRemoteDataSource>(
    () => SalonDetailsRemoteDataSourceImpl(sl<INetworkService>()),
  );
  sl.registerLazySingleton<SalonDetailsRepository>(
    () => SalonDetailsRepositoryImpl(sl<SalonDetailsRemoteDataSource>()),
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
  sl.registerLazySingleton<GetBannersUseCase>(
    () => GetBannersUseCase(sl<SharedRepository>()),
  );
  sl.registerLazySingleton<GetNearestSalonsUseCase>(
    () => GetNearestSalonsUseCase(sl<SharedRepository>()),
  );
  sl.registerLazySingleton<GetNearestCouponsUseCase>(
    () => GetNearestCouponsUseCase(sl<SharedRepository>()),
  );
  sl.registerLazySingleton<GetNearestPackagesUseCase>(
    () => GetNearestPackagesUseCase(sl<SharedRepository>()),
  );
  sl.registerLazySingleton<GetNearestServicesUseCase>(
    () => GetNearestServicesUseCase(sl<SharedRepository>()),
  );
  sl.registerLazySingleton<GetPackageDetailsUseCase>(
    () => GetPackageDetailsUseCase(sl<PackagesRepository>()),
  );
  sl.registerLazySingleton<GetSalonDetailsUseCase>(
    () => GetSalonDetailsUseCase(sl<SalonDetailsRepository>()),
  );
  sl.registerLazySingleton<GetSalonGalleryUseCase>(
    () => GetSalonGalleryUseCase(sl<SalonDetailsRepository>()),
  );
  sl.registerLazySingleton<GetSalonRatingsUseCase>(
    () => GetSalonRatingsUseCase(sl<SalonDetailsRepository>()),
  );
  sl.registerLazySingleton<PackagesRemoteDataSource>(
    () => PackagesRemoteDataSourceImpl(sl<INetworkService>()),
  );
  sl.registerLazySingleton<PackagesRepository>(
    () => PackagesRepositoryImpl(sl<PackagesRemoteDataSource>()),
  );
  sl.registerLazySingleton<GetPackagesUseCase>(
    () => GetPackagesUseCase(sl<PackagesRepository>()),
  );
  sl.registerLazySingleton<ToggleFavoriteUseCase>(
    () => ToggleFavoriteUseCase(sl<SharedRepository>()),
  );
  sl.registerLazySingleton<GetFavoritesUseCase>(
    () => GetFavoritesUseCase(sl<SharedRepository>()),
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
  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<UpdateLocationUseCase>(
    () => UpdateLocationUseCase(sl<AuthRepository>()),
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
      userSession: sl<UserSession>(),
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
      cache: sl<SharedPrefCacheClient>(),
    ),
  );
  sl.registerFactory<SignUpCubit>(
    () => SignUpCubit(
      signUpUseCase: sl<SignUpUseCase>(),
      getCitiesUseCase: sl<GetCitiesUseCase>(),
      getNeighborhoodsUseCase: sl<GetNeighborhoodsUseCase>(),
      secureStorage: sl<SecureStorageCacheClient>(),
      socialLoginUseCase: sl<SocialLoginUseCase>(),
      locationService: sl<LocationService>(),
    ),
  );
  sl.registerFactoryParam<VerifyOtpCubit, String, void>(
    (email, _) => VerifyOtpCubit(
      verifyOtpUseCase: sl<VerifyOtpUseCase>(),
      resendVerificationUseCase: sl<ResendVerificationUseCase>(),
      secureStorage: sl<SecureStorageCacheClient>(),
      cache: sl<SharedPrefCacheClient>(),
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
  // Claim Coupon
  sl.registerLazySingleton<ClaimCouponRemoteDataSource>(
    () => ClaimCouponRemoteDataSourceImpl(sl<INetworkService>()),
  );
  sl.registerLazySingleton<ClaimCouponRepository>(
    () => ClaimCouponRepositoryImpl(sl<ClaimCouponRemoteDataSource>()),
  );
  sl.registerLazySingleton<GetCouponEligibleItemsUseCase>(
    () => GetCouponEligibleItemsUseCase(sl<ClaimCouponRepository>()),
  );
  sl.registerLazySingleton<GetAvailableSlotsUseCase>(
    () => GetAvailableSlotsUseCase(sl<ClaimCouponRepository>()),
  );
  sl.registerLazySingleton<GetAvailableBarbersUseCase>(
    () => GetAvailableBarbersUseCase(sl<ClaimCouponRepository>()),
  );
  sl.registerFactory<ClaimCouponCubit>(
    () => ClaimCouponCubit(
      sl<GetCouponEligibleItemsUseCase>(),
      sl<GetAvailableSlotsUseCase>(),
      sl<GetAvailableBarbersUseCase>(),
      sl<CreateAppointmentUseCase>(),
    ),
  );

  // Booking schedule
  sl.registerLazySingleton<BookingScheduleRemoteDataSource>(
    () => BookingScheduleRemoteDataSourceImpl(sl<INetworkService>()),
  );
  sl.registerLazySingleton<BookingScheduleRepository>(
    () => BookingScheduleRepositoryImpl(sl<BookingScheduleRemoteDataSource>()),
  );
  sl.registerLazySingleton<CreateAppointmentUseCase>(
    () => CreateAppointmentUseCase(sl<BookingScheduleRepository>()),
  );

  // Checkout
  sl.registerLazySingleton<CheckoutRemoteDataSource>(
    () => CheckoutRemoteDataSourceImpl(sl<INetworkService>()),
  );
  sl.registerLazySingleton<CheckoutRepository>(
    () => CheckoutRepositoryImpl(sl<CheckoutRemoteDataSource>()),
  );
  sl.registerLazySingleton<GetPaymentMethodsUseCase>(
    () => GetPaymentMethodsUseCase(sl<CheckoutRepository>()),
  );
  sl.registerLazySingleton<PayAppointmentUseCase>(
    () => PayAppointmentUseCase(sl<CheckoutRepository>()),
  );
  sl.registerFactory<CheckoutCubit>(
    () => CheckoutCubit(
      sl<GetPaymentMethodsUseCase>(),
      sl<PayAppointmentUseCase>(),
    ),
  );

  sl.registerFactory<HomeCubit>(
    () => HomeCubit(
      sl<SecureStorageCacheClient>(),
      sl<SharedPrefCacheClient>(),
      sl<LocationService>(),
      sl<UpdateLocationUseCase>(),
    ),
  );
  sl.registerFactory<BannersCubit>(
    () => BannersCubit(sl<GetBannersUseCase>()),
  );
  sl.registerFactory<CategoriesCubit>(
    () => CategoriesCubit(sl<GetCategoriesUseCase>()),
  );
  sl.registerFactory<SalonsCubit>(
    () => SalonsCubit(sl<GetNearestSalonsUseCase>(), sl<LocationService>(), sl<SharedPrefCacheClient>(), sl<ToggleFavoriteUseCase>()),
  );
  sl.registerFactory<CouponsCubit>(
    () => CouponsCubit(sl<GetNearestCouponsUseCase>(), sl<LocationService>()),
  );
  sl.registerFactory<FeaturedServicesCubit>(
    () => FeaturedServicesCubit(sl<GetNearestServicesUseCase>(), sl<LocationService>(), sl<ToggleFavoriteUseCase>()),
  );
  sl.registerFactory<FeaturedPackagesCubit>(
    () => FeaturedPackagesCubit(sl<GetNearestPackagesUseCase>(), sl<LocationService>(), sl<ToggleFavoriteUseCase>()),
  );
  sl.registerFactory<ExploreCubit>(
    () => ExploreCubit(
      sl<GetCategoriesUseCase>(),
      sl<GetNearestSalonsUseCase>(),
      sl<LocationService>(),
      sl<ToggleFavoriteUseCase>(),
    ),
  );
  sl.registerFactory<SearchCubit>(() => SearchCubit(sl<SharedPrefCacheClient>()));
  sl.registerFactory<SalonDetailsCubit>(
    () => SalonDetailsCubit(
      sl<GetSalonDetailsUseCase>(),
      sl<LocationService>(),
      sl<ToggleFavoriteUseCase>(),
    ),
  );
  sl.registerFactory<SalonGalleryCubit>(
    () => SalonGalleryCubit(sl<GetSalonGalleryUseCase>()),
  );
  sl.registerFactory<SalonRatingsCubit>(
    () => SalonRatingsCubit(sl<GetSalonRatingsUseCase>()),
  );
  sl.registerFactory<PackageDetailsCubit>(
    () => PackageDetailsCubit(sl<GetPackageDetailsUseCase>(), sl<ToggleFavoriteUseCase>()),
  );
  sl.registerFactory<PackagesListCubit>(
    () => PackagesListCubit(
      sl<GetPackagesUseCase>(),
      sl<LocationService>(),
      sl<GetCategoriesUseCase>(),
      sl<ToggleFavoriteUseCase>(),
    ),
  );
  // Bookings
  sl.registerLazySingleton<BookingsRemoteDataSource>(
    () => BookingsRemoteDataSourceImpl(sl<INetworkService>()),
  );
  sl.registerLazySingleton<BookingsRepository>(
    () => BookingsRepositoryImpl(sl<BookingsRemoteDataSource>()),
  );
  sl.registerLazySingleton<GetAppointmentStatusesUseCase>(
    () => GetAppointmentStatusesUseCase(sl<BookingsRepository>()),
  );
  sl.registerLazySingleton<GetAppointmentsUseCase>(
    () => GetAppointmentsUseCase(sl<BookingsRepository>()),
  );
  sl.registerLazySingleton<CancelAppointmentUseCase>(
    () => CancelAppointmentUseCase(sl<BookingsRepository>()),
  );
  sl.registerFactory<BookingsCubit>(
    () => BookingsCubit(
      sl<GetAppointmentStatusesUseCase>(),
      sl<GetAppointmentsUseCase>(),
      sl<CancelAppointmentUseCase>(),
    ),
  );
  sl.registerFactory<FavoritesCubit>(
    () => FavoritesCubit(
      sl<GetFavoritesUseCase>(),
      sl<ToggleFavoriteUseCase>(),
    ),
  );
  sl.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      logoutUseCase: sl<LogoutUseCase>(),
      secureStorage: sl<SecureStorageCacheClient>(),
    ),
  );

  // ─── Book Appointment ────────────────────────────────────────────────────────
  sl.registerLazySingleton<BookAppointmentRemoteDataSource>(
    () => BookAppointmentRemoteDataSourceImpl(sl<INetworkService>()),
  );
  sl.registerLazySingleton<BookAppointmentRepository>(
    () => BookAppointmentRepositoryImpl(
      sl<BookAppointmentRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton<GetSalonServicesUseCase>(
    () => GetSalonServicesUseCase(sl<BookAppointmentRepository>()),
  );
  sl.registerLazySingleton<GetStaffUseCase>(
    () => GetStaffUseCase(sl<BookAppointmentRepository>()),
  );
  sl.registerLazySingleton<GetTimeSlotsUseCase>(
    () => GetTimeSlotsUseCase(sl<BookAppointmentRepository>()),
  );
  sl.registerLazySingleton<ValidateCouponUseCase>(
    () => ValidateCouponUseCase(sl<BookAppointmentRepository>()),
  );
  sl.registerLazySingleton<CreateBookingUseCase>(
    () => CreateBookingUseCase(sl<BookAppointmentRepository>()),
  );
  sl.registerFactory<BookAppointmentCubit>(
    () => BookAppointmentCubit(
      getSalonServicesUseCase: sl<GetSalonServicesUseCase>(),
      getStaffUseCase: sl<GetStaffUseCase>(),
      getTimeSlotsUseCase: sl<GetTimeSlotsUseCase>(),
      validateCouponUseCase: sl<ValidateCouponUseCase>(),
      createBookingUseCase: sl<CreateBookingUseCase>(),
    ),
  );

  // Theme — singleton so RonaqBarberApp and ProfileView share the same instance
  final themeCubit = ThemeCubit(sl<SharedPrefCacheClient>());
  await themeCubit.load();
  sl.registerSingleton<ThemeCubit>(themeCubit);
}
