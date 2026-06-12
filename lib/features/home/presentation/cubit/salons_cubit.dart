import 'dart:developer';

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

  double? _lat;
  double? _lng;
  int _currentPage = 1;
  bool _hasMore = false;

  Future<void> _load() async {
    try {
      final position = await _locationService.getCurrentPosition();
      if (isClosed) return;

      _lat = position?.latitude;
      _lng = position?.longitude;

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
          lat: _lat,
          long: _lng,
        ),
      );

      if (isClosed) return;

      switch (result) {
        case Success(:final data):
          _currentPage = 1;
          _hasMore = data.hasMore;
          emit(SalonsLoaded(
            data.salons,
            location: address,
            hasMore: _hasMore,
          ));
        case Failure():
          emit(const SalonsError());
      }
    } catch (e, st) {
      log('SalonsCubit._load failed', error: e, stackTrace: st, name: 'SalonsCubit');
      if (!isClosed) emit(const SalonsError());
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    final current = state;
    if (current is! SalonsLoaded) return;
    if (current.isLoadingMore) return;

    _currentPage++;
    emit(current.copyWith(isLoadingMore: true));

    try {
      final result = await _getNearestSalonsUseCase(
        NearestSalonsParams(
          lat: _lat,
          long: _lng,
          page: _currentPage,
          perPage: 10,
        ),
      );

      if (isClosed) return;
      final updated = state;
      if (updated is! SalonsLoaded) return;

      switch (result) {
        case Success(:final data):
          _hasMore = data.hasMore;
          emit(updated.copyWith(
            salons: [...updated.salons, ...data.salons],
            isLoadingMore: false,
            hasMore: _hasMore,
          ));
        case Failure():
          _currentPage--;
          emit(updated.copyWith(isLoadingMore: false));
      }
    } catch (e, st) {
      log('SalonsCubit.loadMore failed', error: e, stackTrace: st, name: 'SalonsCubit');
      _currentPage--;
      final updated = state;
      if (!isClosed && updated is SalonsLoaded) {
        emit(updated.copyWith(isLoadingMore: false));
      }
    }
  }

  Future<void> refresh() async {
    emit(const SalonsLoading());
    await _load();
  }
}
