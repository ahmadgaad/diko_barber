import 'package:ronaq_barber/core/shared/domain/entities/nearest_package.dart';

sealed class NearestPackagesListState {
  const NearestPackagesListState();
}

class NearestPackagesListLoading extends NearestPackagesListState {
  const NearestPackagesListLoading();
}

class NearestPackagesListLoaded extends NearestPackagesListState {
  const NearestPackagesListLoaded({
    required this.packages,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  final List<NearestPackage> packages;
  final bool hasMore;
  final bool isLoadingMore;

  NearestPackagesListLoaded copyWith({
    List<NearestPackage>? packages,
    bool? hasMore,
    bool? isLoadingMore,
  }) =>
      NearestPackagesListLoaded(
        packages: packages ?? this.packages,
        hasMore: hasMore ?? this.hasMore,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
}

class NearestPackagesListError extends NearestPackagesListState {
  const NearestPackagesListError();
}
