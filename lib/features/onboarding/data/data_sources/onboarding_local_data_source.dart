import 'dart:convert';

import 'package:zain/core/cache/cache_keys.dart';
import 'package:zain/core/cache/shared_pref_cache_client.dart';
import 'package:zain/features/onboarding/data/models/onboarding_item_model.dart';

abstract class OnboardingLocalDataSource {
  Future<List<OnboardingItemModel>?> getItems();
  Future<void> saveItems(List<OnboardingItemModel> items);
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  OnboardingLocalDataSourceImpl(this._cache);

  final SharedPrefCacheClient _cache;

  @override
  Future<List<OnboardingItemModel>?> getItems() async {
    final raw = await _cache.get(CacheKeys.onboardingItems);
    if (raw == null) return null;

    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .whereType<Map<String, dynamic>>()
        .map(OnboardingItemModel.fromJson)
        .toList();
  }

  @override
  Future<void> saveItems(List<OnboardingItemModel> items) async {
    final encoded = jsonEncode(items.map((e) => e.toJson()).toList());
    await _cache.set(CacheKeys.onboardingItems, encoded);
  }
}
