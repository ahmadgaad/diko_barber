import 'package:ronaq_barber/core/shared/domain/entities/nearest_service.dart';

sealed class FeaturedServicesState {
  const FeaturedServicesState();
}

class FeaturedServicesLoading extends FeaturedServicesState {
  const FeaturedServicesLoading();
}

class FeaturedServicesLoaded extends FeaturedServicesState {
  const FeaturedServicesLoaded(this.services);
  final List<NearestService> services;
}

class FeaturedServicesError extends FeaturedServicesState {
  const FeaturedServicesError();
}
