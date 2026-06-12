import 'package:ronaq_barber/core/shared/domain/entities/salon.dart';

sealed class SalonsState {
  const SalonsState();
}

class SalonsLoading extends SalonsState {
  const SalonsLoading();
}

class SalonsLoaded extends SalonsState {
  const SalonsLoaded(
    this.salons, {
    this.location,
    this.isLoadingMore = false,
    this.hasMore = false,
  });

  final List<Salon> salons;
  final String? location;
  final bool isLoadingMore;
  final bool hasMore;

  SalonsLoaded copyWith({
    List<Salon>? salons,
    bool? isLoadingMore,
    bool? hasMore,
  }) =>
      SalonsLoaded(
        salons ?? this.salons,
        location: location,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        hasMore: hasMore ?? this.hasMore,
      );
}

class SalonsError extends SalonsState {
  const SalonsError();
}
