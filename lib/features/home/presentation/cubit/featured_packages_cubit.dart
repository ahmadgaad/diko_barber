import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/core/services/location_service.dart';
import 'package:zain/core/shared/domain/entities/favorite_type.dart';
import 'package:zain/core/shared/domain/entities/nearest_packages_params.dart';
import 'package:zain/core/shared/domain/use_cases/get_nearest_packages_use_case.dart';
import 'package:zain/core/shared/domain/use_cases/toggle_favorite_use_case.dart';

import 'featured_packages_state.dart';

class FeaturedPackagesCubit extends Cubit<FeaturedPackagesState> {
  FeaturedPackagesCubit(
    this._getNearestPackagesUseCase,
    this._locationService,
    this._toggleFavoriteUseCase,
  ) : super(const FeaturedPackagesLoading()) {
    _load();
    _eventSub = _toggleFavoriteUseCase.events.listen(_onFavoriteEvent);
  }

  final GetNearestPackagesUseCase _getNearestPackagesUseCase;
  final LocationService _locationService;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;

  late final StreamSubscription<FavoriteToggleEvent> _eventSub;
  final _pendingToggles = <int>{};

  void _onFavoriteEvent(FavoriteToggleEvent event) {
    if (event.type != FavoriteType.package) return;
    if (_pendingToggles.contains(event.id)) return;
    final current = state;
    if (current is! FeaturedPackagesLoaded) return;
    emit(current.copyWith(
      packages: current.packages
          .map((p) => p.id == event.id ? p.copyWith(isFavorite: event.isFavorite) : p)
          .toList(),
    ));
  }

  Future<void> toggleFavorite(int packageId) async {
    final current = state;
    if (current is! FeaturedPackagesLoaded) return;

    final pkg = current.packages.firstWhere((p) => p.id == packageId);
    final newIsFavorite = !pkg.isFavorite;
    _pendingToggles.add(packageId);
    emit(current.copyWith(
      packages: current.packages
          .map((p) => p.id == packageId ? p.copyWith(isFavorite: newIsFavorite) : p)
          .toList(),
    ));

    final result = await _toggleFavoriteUseCase(
      id: packageId,
      type: FavoriteType.package,
      isFavorite: newIsFavorite,
    );
    _pendingToggles.remove(packageId);

    if (result.isFailure) {
      emit(current);
    }
  }

  Future<void> refresh() async {
    emit(const FeaturedPackagesLoading());
    await _load();
  }

  @override
  Future<void> close() {
    _eventSub.cancel();
    return super.close();
  }

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
}
