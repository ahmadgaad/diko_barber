import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/core/services/location_service.dart';
import 'package:ronaq_barber/core/shared/domain/entities/nearest_services_params.dart';
import 'package:ronaq_barber/core/shared/domain/use_cases/get_nearest_services_use_case.dart';

import 'featured_services_state.dart';

class FeaturedServicesCubit extends Cubit<FeaturedServicesState> {
  FeaturedServicesCubit(
    this._getNearestServicesUseCase,
    this._locationService,
  ) : super(const FeaturedServicesLoading()) {
    _load();
  }

  final GetNearestServicesUseCase _getNearestServicesUseCase;
  final LocationService _locationService;

  Future<void> _load() async {
    try {
      final position = await _locationService.getCurrentPosition();
      if (isClosed) return;

      final result = await _getNearestServicesUseCase(
        NearestServicesParams(
          lat: position?.latitude,
          long: position?.longitude,
        ),
      );

      if (isClosed) return;

      switch (result) {
        case Success(:final data):
          emit(FeaturedServicesLoaded(data));
        case Failure():
          emit(const FeaturedServicesError());
      }
    } catch (e, st) {
      log('FeaturedServicesCubit._load failed', error: e, stackTrace: st, name: 'FeaturedServicesCubit');
      if (!isClosed) emit(const FeaturedServicesError());
    }
  }

  Future<void> refresh() async {
    emit(const FeaturedServicesLoading());
    await _load();
  }
}
