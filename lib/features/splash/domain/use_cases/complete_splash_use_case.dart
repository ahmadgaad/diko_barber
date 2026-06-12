import 'package:ronaq_barber/core/cache/cache_keys.dart';
import 'package:ronaq_barber/core/cache/secure_storage_cache_client.dart';
import 'package:ronaq_barber/core/router/app_routes.dart';
import 'package:ronaq_barber/features/onboarding/domain/repositories/onboarding_repository.dart';

class CompleteSplashUseCase {
  const CompleteSplashUseCase(this._onboardingRepository, this._secureStorage);

  final OnboardingRepository _onboardingRepository;
  final SecureStorageCacheClient _secureStorage;

  Future<String> call() async {
    // await sl<SharedPrefCacheClient>().clear();
    // await _secureStorage.clear();
    final token = await _secureStorage.get(CacheKeys.userAccessToken);

    if (token != null && token.isNotEmpty) {
      final isVerifiedStr = await _secureStorage.get(CacheKeys.userIsVerified);
      if (isVerifiedStr == 'true') return AppRoutes.home;
    }

    final seen = await _onboardingRepository.hasSeenOnboarding();
    return seen ? AppRoutes.login : AppRoutes.onboarding;
  }
}
