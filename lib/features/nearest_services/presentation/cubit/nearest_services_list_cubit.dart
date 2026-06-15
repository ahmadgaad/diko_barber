import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/core/services/location_service.dart';
import 'package:zain/core/shared/domain/entities/nearest_services_params.dart';
import 'package:zain/core/shared/domain/use_cases/get_nearest_services_use_case.dart';

import 'nearest_services_list_state.dart';

class NearestServicesListCubit extends Cubit<NearestServicesListState> {
  NearestServicesListCubit(this._useCase, this._locationService)
      : super(const NearestServicesListLoading()) {
    _load();
  }

  static const _perPage = 20;

  final GetNearestServicesUseCase _useCase;
  final LocationService _locationService;
  Position? _position;
  int _page = 1;

  Future<void> _load() async {
    try {
      _position = await _locationService.getCurrentPosition();
      if (isClosed) return;

      final result = await _useCase(NearestServicesParams(
        lat: _position?.latitude,
        long: _position?.longitude,
        page: _page,
        perPage: _perPage,
      ));

      if (isClosed) return;

      switch (result) {
        case Success(:final data):
          emit(NearestServicesListLoaded(
            services: data,
            hasMore: data.length >= _perPage,
          ));
        case Failure():
          emit(const NearestServicesListError());
      }
    } catch (e, st) {
      log('NearestServicesListCubit._load failed', error: e, stackTrace: st);
      if (!isClosed) emit(const NearestServicesListError());
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! NearestServicesListLoaded) return;
    if (!current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));
    _page++;

    try {
      final result = await _useCase(NearestServicesParams(
        lat: _position?.latitude,
        long: _position?.longitude,
        page: _page,
        perPage: _perPage,
      ));

      if (isClosed) return;

      switch (result) {
        case Success(:final data):
          emit(NearestServicesListLoaded(
            services: [...current.services, ...data],
            hasMore: data.length >= _perPage,
          ));
        case Failure():
          _page--;
          emit(current.copyWith(isLoadingMore: false));
      }
    } catch (e, st) {
      log('NearestServicesListCubit.loadMore failed', error: e, stackTrace: st);
      _page--;
      if (!isClosed) emit(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> refresh() async {
    _page = 1;
    emit(const NearestServicesListLoading());
    await _load();
  }
}
