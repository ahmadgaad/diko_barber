import 'package:ronaq_barber/core/shared/domain/entities/nearest_package.dart';
import 'package:ronaq_barber/core/shared/domain/entities/nearest_service.dart';
import 'package:ronaq_barber/core/shared/domain/entities/salon.dart';

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
  final List<NearestPackage> packages;
  final List<NearestService> services;

  FavoritesLoaded copyWith({
    List<Salon>? salons,
    List<NearestPackage>? packages,
    List<NearestService>? services,
  }) =>
      FavoritesLoaded(
        salons: salons ?? this.salons,
        packages: packages ?? this.packages,
        services: services ?? this.services,
      );
}

class FavoritesError extends FavoritesState {
  const FavoritesError();
}
