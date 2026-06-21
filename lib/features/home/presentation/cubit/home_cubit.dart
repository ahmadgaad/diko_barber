import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/cache/cache_keys.dart';
import 'package:zain/core/cache/secure_storage_cache_client.dart';
import 'package:zain/core/cache/shared_pref_cache_client.dart';
import 'package:zain/core/services/location_service.dart';
import 'package:zain/features/auth/domain/use_cases/update_location_use_case.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this._secureStorage,
    this._cache,
    this._locationService,
    this._updateLocationUseCase,
  ) : super(const HomeLoaded()) {
    _load();
  }

  final SecureStorageCacheClient _secureStorage;
  final SharedPrefCacheClient _cache;
  final LocationService _locationService;
  final UpdateLocationUseCase _updateLocationUseCase;

  HomeLoaded get _loaded => state as HomeLoaded;

  Future<void> _load() async {
    final name = await _secureStorage.get(CacheKeys.userName);
    final location = await _cache.get(CacheKeys.userLocation);
    if (isClosed) return;
    emit(HomeLoaded(userName: name ?? '', location: location));
    _syncLocationToServer();
  }

  void updateLocation(String location) {
    if (state is! HomeLoaded) return;
    emit(_loaded.copyWith(location: location));
  }

  /// Best-effort: push the user's real current location to the server on app
  /// open. Runs silently in the background — failures are non-blocking and do
  /// not surface to the UI.
  Future<void> _syncLocationToServer() async {
    final position = await _locationService.getCurrentPosition();
    if (isClosed || position == null) return;

    final address = await _locationService.getAddressFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (isClosed) return;

    if (address != null) {
      await _cache.set(CacheKeys.userLocation, address);
      if (!isClosed && state is HomeLoaded) {
        emit(_loaded.copyWith(location: address));
      }
    }

    await _updateLocationUseCase(
      lat: position.latitude,
      long: position.longitude,
      location: address ?? (state is HomeLoaded ? _loaded.location : null) ?? '',
    );
  }
}
