import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/cache/cache_keys.dart';
import 'package:ronaq_barber/core/cache/shared_pref_cache_client.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/core/services/location_service.dart';
import 'package:ronaq_barber/core/shared/domain/entities/nearest_salons_params.dart';
import 'package:ronaq_barber/core/shared/domain/use_cases/get_nearest_salons_use_case.dart';

import 'salons_state.dart';

class SalonsCubit extends Cubit<SalonsState> {
  SalonsCubit(
    this._getNearestSalonsUseCase,
    this._locationService,
    this._cache,
  ) : super(const SalonsLoading()) {
    _load();
  }

  final GetNearestSalonsUseCase _getNearestSalonsUseCase;
  final LocationService _locationService;
  final SharedPrefCacheClient _cache;

  Future<void> _load() async {
    final position = await _locationService.getCurrentPosition();
    if (isClosed) return;

    String? address;
    if (position != null) {
      address = await _locationService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (address != null) await _cache.set(CacheKeys.userLocation, address);
    }

    if (isClosed) return;

    final result = await _getNearestSalonsUseCase(
      NearestSalonsParams(
        isHome: true,
        lat: position?.latitude,
        long: position?.longitude,
      ),
    );

    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        emit(SalonsLoaded(data, location: address));
      case Failure():
        emit(const SalonsError());
    }
  }

  Future<void> refresh() async {
    emit(const SalonsLoading());
    await _load();
  }
}
