import 'package:zain/core/cache/cache_keys.dart';
import 'package:zain/core/cache/shared_pref_cache_client.dart';
import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/onboarding/data/data_sources/onboarding_local_data_source.dart';
import 'package:zain/features/onboarding/data/data_sources/onboarding_remote_data_source.dart';
import 'package:zain/features/onboarding/data/models/onboarding_item_model.dart';
import 'package:zain/features/onboarding/domain/entities/onboarding_item.dart';
import 'package:zain/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl({
    required this.cache,
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final SharedPrefCacheClient cache;
  final OnboardingRemoteDataSource remoteDataSource;
  final OnboardingLocalDataSource localDataSource;

  List<OnboardingItem>? _cachedItems;

  @override
  Future<bool> hasSeenOnboarding() async {
    final value = await cache.get(CacheKeys.onboardingSeen);
    return value == 'true';
  }

  @override
  Future<void> markOnboardingSeen() =>
      cache.set(CacheKeys.onboardingSeen, 'true');

  @override
  Future<Result<ApiErrorModel, List<OnboardingItem>>> getItems() async {
    if (_cachedItems != null) return Success(_cachedItems!);

    final local = await localDataSource.getItems();
    if (local != null) {
      _cachedItems = local;
      return Success(local);
    }

    try {
      final response = await remoteDataSource.getItems();

      if (response.isError || response.data == null) {
        return Failure(
          ApiErrorModel(message: response.message ?? 'حدث خطأ غير معروف'),
        );
      }

      final items = (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map(OnboardingItemModel.fromJson)
          .toList();

      _cachedItems = items;
      await localDataSource.saveItems(items);
      return Success(items);
    } catch (_) {
      return Failure(ApiErrorModel(message: 'حدث خطأ غير معروف'));
    }
  }
}
