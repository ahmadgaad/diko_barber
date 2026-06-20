import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/cache/cache_keys.dart';
import 'package:zain/core/cache/secure_storage_cache_client.dart';
import 'package:zain/core/cache/shared_pref_cache_client.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/auth/domain/use_cases/update_location_use_case.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._secureStorage, this._cache, this._updateLocationUseCase)
      : super(const HomeLoaded()) {
    _load();
  }

  final SecureStorageCacheClient _secureStorage;
  final SharedPrefCacheClient _cache;
  final UpdateLocationUseCase _updateLocationUseCase;

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

  Future<void> updateUserLocation({
    required double lat,
    required double lng,
    String? address,
  }) async {
    if (state is! HomeLoaded || _loaded.isUpdatingLocation) return;

    emit(_loaded.copyWith(
      isUpdatingLocation: true,
      locationError: () => null,
    ));

    final result = await _updateLocationUseCase(
      lat: lat,
      long: lng,
      location: address ?? '',
    );
    if (isClosed) return;

    switch (result) {
      case Success():
        if (address != null) {
          await _cache.set(CacheKeys.userLocation, address);
        }
        emit(_loaded.copyWith(
          location: address,
          isUpdatingLocation: false,
          locationUpdated: true,
        ));
        emit(_loaded.copyWith(locationUpdated: false));
      case Failure(:final error):
        emit(_loaded.copyWith(
          isUpdatingLocation: false,
          locationError: () => error.message,
        ));
        emit(_loaded.copyWith(locationError: () => null));
    }
  }
}
