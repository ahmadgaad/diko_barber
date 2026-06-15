import 'package:zain/core/shared/domain/entities/nearest_package.dart';
import 'package:zain/core/shared/domain/entities/nearest_service.dart';
import 'package:zain/core/shared/domain/entities/salon.dart';

sealed class FavoritesTabResult {
  const FavoritesTabResult();
}

class SalonFavoritesResult extends FavoritesTabResult {
  const SalonFavoritesResult(this.items);
  final List<Salon> items;
}

class PackageFavoritesResult extends FavoritesTabResult {
  const PackageFavoritesResult(this.items);
  final List<NearestPackage> items;
}

class ServiceFavoritesResult extends FavoritesTabResult {
  const ServiceFavoritesResult(this.items);
  final List<NearestService> items;
}
