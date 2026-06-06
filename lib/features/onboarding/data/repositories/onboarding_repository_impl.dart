import 'package:ronaq_barber/core/cache/cache_keys.dart';
import 'package:ronaq_barber/core/cache/shared_pref_cache_client.dart';
import 'package:ronaq_barber/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl(this._cache);

  final SharedPrefCacheClient _cache;

  @override
  Future<bool> hasSeenOnboarding() async {
    final value = await _cache.get(CacheKeys.onboardingSeen);
    return value == 'true';
  }

  @override
  Future<void> markOnboardingSeen() =>
      _cache.set(CacheKeys.onboardingSeen, 'true');
}
