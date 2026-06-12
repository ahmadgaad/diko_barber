import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/core/services/location_service.dart';
import 'package:ronaq_barber/core/shared/domain/entities/nearest_packages_params.dart';
import 'package:ronaq_barber/core/shared/domain/use_cases/get_nearest_packages_use_case.dart';

import 'nearest_packages_list_state.dart';

class NearestPackagesListCubit extends Cubit<NearestPackagesListState> {
  NearestPackagesListCubit(this._useCase, this._locationService)
      : super(const NearestPackagesListLoading()) {
    _load();
  }

  static const _perPage = 20;

  final GetNearestPackagesUseCase _useCase;
  final LocationService _locationService;
  Position? _position;
  int _page = 1;

  Future<void> _load() async {
    try {
      _position = await _locationService.getCurrentPosition();
      if (isClosed) return;

      final result = await _useCase(NearestPackagesParams(
        lat: _position?.latitude,
        long: _position?.longitude,
        page: _page,
        perPage: _perPage,
      ));

      if (isClosed) return;

      switch (result) {
        case Success(:final data):
          emit(NearestPackagesListLoaded(
            packages: data,
            hasMore: data.length >= _perPage,
          ));
        case Failure():
          emit(const NearestPackagesListError());
      }
    } catch (e, st) {
      log('NearestPackagesListCubit._load failed', error: e, stackTrace: st);
      if (!isClosed) emit(const NearestPackagesListError());
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! NearestPackagesListLoaded) return;
    if (!current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));
    _page++;

    try {
      final result = await _useCase(NearestPackagesParams(
        lat: _position?.latitude,
        long: _position?.longitude,
        page: _page,
        perPage: _perPage,
      ));

      if (isClosed) return;

      switch (result) {
        case Success(:final data):
          emit(NearestPackagesListLoaded(
            packages: [...current.packages, ...data],
            hasMore: data.length >= _perPage,
          ));
        case Failure():
          _page--;
          emit(current.copyWith(isLoadingMore: false));
      }
    } catch (e, st) {
      log('NearestPackagesListCubit.loadMore failed', error: e, stackTrace: st);
      _page--;
      if (!isClosed) emit(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> refresh() async {
    _page = 1;
    emit(const NearestPackagesListLoading());
    await _load();
  }
}
