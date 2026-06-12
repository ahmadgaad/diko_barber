import 'package:ronaq_barber/core/shared/domain/entities/nearest_package.dart';

sealed class FeaturedPackagesState {
  const FeaturedPackagesState();
}

class FeaturedPackagesLoading extends FeaturedPackagesState {
  const FeaturedPackagesLoading();
}

class FeaturedPackagesLoaded extends FeaturedPackagesState {
  const FeaturedPackagesLoaded(this.packages);
  final List<NearestPackage> packages;
}

class FeaturedPackagesError extends FeaturedPackagesState {
  const FeaturedPackagesError();
}
