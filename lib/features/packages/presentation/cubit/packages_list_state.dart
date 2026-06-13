import 'package:ronaq_barber/core/shared/domain/entities/nearest_package.dart';

sealed class PackagesListState {
  const PackagesListState();
}

class PackagesListLoading extends PackagesListState {
  const PackagesListLoading();
}

class PackagesListLoaded extends PackagesListState {
  const PackagesListLoaded({
    required this.packages,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.loadMoreFailed = false,
    this.search = '',
    this.categoryIds = const [],
    this.sortBy = const [],
  });

  final List<NearestPackage> packages;
  final bool isLoadingMore;
  final bool hasMore;
  final bool loadMoreFailed;
  final String search;
  final List<int> categoryIds;
  final List<String> sortBy;

  int get activeFiltersCount => categoryIds.length + sortBy.length;

  PackagesListLoaded copyWith({
    List<NearestPackage>? packages,
    bool? isLoadingMore,
    bool? hasMore,
    bool? loadMoreFailed,
    String? search,
    List<int>? categoryIds,
    List<String>? sortBy,
  }) {
    return PackagesListLoaded(
      packages: packages ?? this.packages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
      search: search ?? this.search,
      categoryIds: categoryIds ?? this.categoryIds,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

class PackagesListError extends PackagesListState {
  const PackagesListError();
}
