import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/services/location_service.dart';
import 'package:ronaq_barber/core/shared/domain/entities/favorite_type.dart';
import 'package:ronaq_barber/features/salon_details/domain/use_cases/get_salon_details_use_case.dart';
import 'package:ronaq_barber/core/shared/domain/use_cases/toggle_favorite_use_case.dart';
import 'package:ronaq_barber/features/salon_details/presentation/cubit/salon_details_state.dart';

class SalonDetailsCubit extends Cubit<SalonDetailsState> {
  SalonDetailsCubit(
    this._getSalonDetails,
    this._locationService,
    this._toggleFavoriteUseCase,
  ) : super(const SalonDetailsLoading()) {
    _eventSub = _toggleFavoriteUseCase.events.listen(_onFavoriteEvent);
  }

  final GetSalonDetailsUseCase _getSalonDetails;
  final LocationService _locationService;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;

  late final StreamSubscription<FavoriteToggleEvent> _eventSub;
  final _pendingToggles = <int>{};

  Future<void> load(int salonId, {String? couponCode}) async {
    emit(const SalonDetailsLoading());

    final position = await _locationService.getCurrentPosition();
    if (isClosed) return;

    final result = await _getSalonDetails(
      salonId,
      lat: position?.latitude,
      long: position?.longitude,
    );
    if (isClosed) return;

    result.when(
      failure: (_) => emit(const SalonDetailsError()),
      success: (salon) => emit(SalonDetailsLoaded(
        salon: salon,
        isFavorite: salon.isFavorite,
        couponCode: couponCode,
      )),
    );
  }

  void toggleServiceSelection(int serviceId) {
    final current = state;
    if (current is! SalonDetailsLoaded) return;
    final ids = Set<int>.from(current.selectedServiceIds);
    if (ids.contains(serviceId)) {
      ids.remove(serviceId);
    } else {
      ids.add(serviceId);
    }
    emit(current.copyWith(selectedServiceIds: ids));
  }

  void togglePackageSelection(int packageId) {
    final current = state;
    if (current is! SalonDetailsLoaded) return;
    final ids = Set<int>.from(current.selectedPackageIds);
    if (ids.contains(packageId)) {
      ids.remove(packageId);
    } else {
      ids.add(packageId);
    }
    emit(current.copyWith(selectedPackageIds: ids));
  }

  Future<void> toggleFavorite() async {
    final current = state;
    if (current is! SalonDetailsLoaded) return;

    final salonId = current.salon.id;
    final newIsFavorite = !current.isFavorite;
    _pendingToggles.add(salonId);
    emit(current.copyWith(isFavorite: newIsFavorite));

    final result = await _toggleFavoriteUseCase(
      id: salonId,
      type: FavoriteType.salon,
      isFavorite: newIsFavorite,
    );
    _pendingToggles.remove(salonId);

    if (result.isFailure && !isClosed) {
      emit(current);
    }
  }

  void _onFavoriteEvent(FavoriteToggleEvent event) {
    if (event.type != FavoriteType.salon) return;
    if (_pendingToggles.contains(event.id)) return;
    final current = state;
    if (current is! SalonDetailsLoaded) return;
    if (current.salon.id != event.id) return;
    emit(current.copyWith(isFavorite: event.isFavorite));
  }

  @override
  Future<void> close() {
    _eventSub.cancel();
    return super.close();
  }
}
