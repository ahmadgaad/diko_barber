import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/core/services/location_service.dart';
import 'package:ronaq_barber/core/shared/domain/entities/favorite_type.dart';
import 'package:ronaq_barber/core/shared/domain/entities/nearest_services_params.dart';
import 'package:ronaq_barber/core/shared/domain/use_cases/get_nearest_services_use_case.dart';
import 'package:ronaq_barber/core/shared/domain/use_cases/toggle_favorite_use_case.dart';

import 'featured_services_state.dart';

class FeaturedServicesCubit extends Cubit<FeaturedServicesState> {
  FeaturedServicesCubit(
    this._getNearestServicesUseCase,
    this._locationService,
    this._toggleFavoriteUseCase,
  ) : super(const FeaturedServicesLoading()) {
    _load();
    _eventSub = _toggleFavoriteUseCase.events.listen(_onFavoriteEvent);
  }

  final GetNearestServicesUseCase _getNearestServicesUseCase;
  final LocationService _locationService;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;

  late final StreamSubscription<FavoriteToggleEvent> _eventSub;
  final _pendingToggles = <int>{};

  void _onFavoriteEvent(FavoriteToggleEvent event) {
    if (event.type != FavoriteType.service) return;
    if (_pendingToggles.contains(event.id)) return;
    final current = state;
    if (current is! FeaturedServicesLoaded) return;
    emit(current.copyWith(
      services: current.services
          .map((s) => s.id == event.id ? s.copyWith(isFavorite: event.isFavorite) : s)
          .toList(),
    ));
  }

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

  Future<void> toggleFavorite(int serviceId) async {
    final current = state;
    if (current is! FeaturedServicesLoaded) return;

    final svc = current.services.firstWhere((s) => s.id == serviceId);
    final newIsFavorite = !svc.isFavorite;
    _pendingToggles.add(serviceId);
    emit(current.copyWith(
      services: current.services
          .map((s) => s.id == serviceId ? s.copyWith(isFavorite: newIsFavorite) : s)
          .toList(),
    ));

    final result = await _toggleFavoriteUseCase(
      id: serviceId,
      type: FavoriteType.service,
      isFavorite: newIsFavorite,
    );
    _pendingToggles.remove(serviceId);

    if (result.isFailure) {
      emit(current);
    }
  }

  Future<void> refresh() async {
    emit(const FeaturedServicesLoading());
    await _load();
  }

  @override
  Future<void> close() {
    _eventSub.cancel();
    return super.close();
  }
}
