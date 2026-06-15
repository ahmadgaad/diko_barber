import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/core/services/location_service.dart';
import 'package:zain/core/shared/domain/entities/nearest_coupons_params.dart';
import 'package:zain/core/shared/domain/use_cases/get_nearest_coupons_use_case.dart';

import 'coupons_state.dart';

class CouponsCubit extends Cubit<CouponsState> {
  CouponsCubit(this._getNearestCouponsUseCase, this._locationService)
      : super(const CouponsLoading()) {
    _load();
  }

  final GetNearestCouponsUseCase _getNearestCouponsUseCase;
  final LocationService _locationService;

  Future<void> _load() async {
    try {
      final position = await _locationService.getCurrentPosition();
      if (isClosed) return;

      final result = await _getNearestCouponsUseCase(
        NearestCouponsParams(
          lat: position?.latitude,
          long: position?.longitude,
        ),
      );

      if (isClosed) return;

      switch (result) {
        case Success(:final data):
          emit(CouponsLoaded(data));
        case Failure():
          emit(const CouponsError());
      }
    } catch (e, st) {
      log('CouponsCubit._load failed', error: e, stackTrace: st, name: 'CouponsCubit');
      if (!isClosed) emit(const CouponsError());
    }
  }

    Future<void> refresh() async {
    emit(const CouponsLoading());
    await _load();
  }
}
