import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/core/shared/domain/entities/favorite_type.dart';
import 'package:ronaq_barber/core/shared/domain/entities/favorites_tab_result.dart';
import 'package:ronaq_barber/core/shared/domain/use_cases/get_favorites_use_case.dart';
import 'package:ronaq_barber/core/shared/domain/use_cases/toggle_favorite_use_case.dart';
import 'package:ronaq_barber/features/favorites/presentation/cubit/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(
    this._getFavorites,
    this._toggleFavoriteUseCase,
  ) : super(const FavoritesLoading()) {
    load();
    _eventSub = _toggleFavoriteUseCase.events.listen(_onFavoriteEvent);
  }

  final GetFavoritesUseCase _getFavorites;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;

  late final StreamSubscription<FavoriteToggleEvent> _eventSub;

  Future<void> load() async {
    emit(const FavoritesLoading());

    final (salonsResult, packagesResult, servicesResult) = await (
      _getFavorites(FavoriteType.salon),
      _getFavorites(FavoriteType.package),
      _getFavorites(FavoriteType.service),
    ).wait;

    if (isClosed) return;

    if (salonsResult.isFailure && packagesResult.isFailure && servicesResult.isFailure) {
      emit(const FavoritesError());
      return;
    }

    emit(FavoritesLoaded(
      salons: switch (salonsResult) {
        Success(data: SalonFavoritesResult(:final items)) => items,
        _ => [],
      },
      packages: switch (packagesResult) {
        Success(data: PackageFavoritesResult(:final items)) => items,
        _ => [],
      },
      services: switch (servicesResult) {
        Success(data: ServiceFavoritesResult(:final items)) => items,
        _ => [],
      },
    ));
  }

  Future<void> toggleFavorite(int id, FavoriteType type) async {
    final current = state;
    if (current is! FavoritesLoaded) return;

    emit(_removeItem(current, id, type));

    final result = await _toggleFavoriteUseCase(
      id: id,
      type: type,
      isFavorite: false,
    );
    if (result.isFailure) {
      emit(current);
    }
  }

  void _onFavoriteEvent(FavoriteToggleEvent event) {
    final current = state;
    if (current is! FavoritesLoaded) return;

    if (!event.isFavorite) {
      emit(_removeItem(current, event.id, event.type));
    } else {
      _reloadTab(event.type);
    }
  }

  Future<void> _reloadTab(FavoriteType type) async {
    final current = state;
    if (current is! FavoritesLoaded) return;

    final result = await _getFavorites(type);
    if (isClosed) return;
    if (result.isFailure) return;

    emit(switch (result) {
      Success(data: SalonFavoritesResult(:final items)) =>
        current.copyWith(salons: items),
      Success(data: PackageFavoritesResult(:final items)) =>
        current.copyWith(packages: items),
      Success(data: ServiceFavoritesResult(:final items)) =>
        current.copyWith(services: items),
      _ => current,
    });
  }

  FavoritesLoaded _removeItem(FavoritesLoaded state, int id, FavoriteType type) =>
      switch (type) {
        FavoriteType.salon =>
          state.copyWith(salons: state.salons.where((s) => s.id != id).toList()),
        FavoriteType.service =>
          state.copyWith(services: state.services.where((s) => s.id != id).toList()),
        FavoriteType.package =>
          state.copyWith(packages: state.packages.where((p) => p.id != id).toList()),
      };

  @override
  Future<void> close() {
    _eventSub.cancel();
    return super.close();
  }
}
