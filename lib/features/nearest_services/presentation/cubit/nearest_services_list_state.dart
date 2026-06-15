import 'package:zain/core/shared/domain/entities/nearest_service.dart';

sealed class NearestServicesListState {
  const NearestServicesListState();
}

class NearestServicesListLoading extends NearestServicesListState {
  const NearestServicesListLoading();
}

class NearestServicesListLoaded extends NearestServicesListState {
  const NearestServicesListLoaded({
    required this.services,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  final List<NearestService> services;
  final bool hasMore;
  final bool isLoadingMore;

  NearestServicesListLoaded copyWith({
    List<NearestService>? services,
    bool? hasMore,
    bool? isLoadingMore,
  }) =>
      NearestServicesListLoaded(
        services: services ?? this.services,
        hasMore: hasMore ?? this.hasMore,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
}

class NearestServicesListError extends NearestServicesListState {
  const NearestServicesListError();
}
