import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/cache/cache_keys.dart';
import 'package:ronaq_barber/core/cache/secure_storage_cache_client.dart';
import 'package:ronaq_barber/core/cache/shared_pref_cache_client.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._secureStorage, this._cache) : super(const HomeLoaded()) {
    _load();
  }

  final SecureStorageCacheClient _secureStorage;
  final SharedPrefCacheClient _cache;

  HomeLoaded get _loaded => state as HomeLoaded;

  Future<void> _load() async {
    final name = await _secureStorage.get(CacheKeys.userName);
    final location = await _cache.get(CacheKeys.userLocation);
    emit(HomeLoaded(userName: name ?? '', location: location));
  }

  void updateLocation(String location) {
    if (state is! HomeLoaded) return;
    emit(_loaded.copyWith(location: location));
  }
}
