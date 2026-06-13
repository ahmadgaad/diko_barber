import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/core/services/location_service.dart';
import 'package:ronaq_barber/core/shared/domain/entities/nearest_packages_params.dart';
import 'package:ronaq_barber/core/shared/domain/use_cases/get_nearest_packages_use_case.dart';

import 'featured_packages_state.dart';

class FeaturedPackagesCubit extends Cubit<FeaturedPackagesState> {
  FeaturedPackagesCubit(
    this._getNearestPackagesUseCase,
    this._locationService,
  ) : super(const FeaturedPackagesLoading()) {
    _load();
  }

  final GetNearestPackagesUseCase _getNearestPackagesUseCase;
  final LocationService _locationService;

  Future<void> _load() async {
    try {
      final position = await _locationService.getCurrentPosition();
      if (isClosed) return;

      final result = await _getNearestPackagesUseCase(
        NearestPackagesParams(
          lat: position?.latitude,
          long: position?.longitude,
          isHome: true,
        ),
      );

      if (isClosed) return;

      switch (result) {
        case Success(:final data):
          emit(FeaturedPackagesLoaded(data));
        case Failure():
          emit(const FeaturedPackagesError());
      }
    } catch (e, st) {
      log('FeaturedPackagesCubit._load failed', error: e, stackTrace: st, name: 'FeaturedPackagesCubit');
      if (!isClosed) emit(const FeaturedPackagesError());
    }
  }

  Future<void> refresh() async {
    emit(const FeaturedPackagesLoading());
    await _load();
  }
}
