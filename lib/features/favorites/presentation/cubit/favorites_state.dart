import 'package:ronaq_barber/core/shared/domain/entities/package.dart';
import 'package:ronaq_barber/core/shared/domain/entities/salon.dart';
import 'package:ronaq_barber/core/shared/domain/entities/salon_service.dart';

sealed class FavoritesState {
  const FavoritesState();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

class FavoritesLoaded extends FavoritesState {
  const FavoritesLoaded({
    required this.salons,
    required this.packages,
    required this.services,
  });

  final List<Salon> salons;
  final List<Package> packages;
  final List<SalonService> services;
}

class FavoritesError extends FavoritesState {
  const FavoritesError();
}
