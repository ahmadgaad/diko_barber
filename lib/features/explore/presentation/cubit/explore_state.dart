import 'package:ronaq_barber/core/shared/domain/entities/category.dart';
import 'package:ronaq_barber/core/shared/domain/entities/salon.dart';

sealed class ExploreState {
  const ExploreState();
}

class ExploreLoading extends ExploreState {
  const ExploreLoading();
}

class ExploreLoaded extends ExploreState {
  const ExploreLoaded({
    required this.salons,
    required this.categories,
    this.query = '',
    this.selectedCategory,
    this.highlightedSalonId,
    this.isLoadingSalons = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.loadMoreFailed = false,
    this.userLat,
    this.userLng,
  });

  /// Salons currently displayed (may be stale while [isLoadingSalons] is true).
  final List<Salon> salons;

  /// All available category filter chips from the API.
  final List<Category> categories;

  final String query;

  /// `null` means "All".
  final Category? selectedCategory;

  /// The salon whose map pin is currently highlighted (tapped).
  final int? highlightedSalonId;

  /// True while a filtered/searched salon fetch is in flight (replaces list).
  final bool isLoadingSalons;

  /// True while the next page is being fetched (appended to list).
  final bool isLoadingMore;

  /// Whether more pages are available.
  final bool hasMore;

  /// Flips to true when a load-more request fails. Resets to false on next attempt.
  final bool loadMoreFailed;

  /// Device location — null if permission was denied.
  final double? userLat;
  final double? userLng;

  ExploreLoaded copyWith({
    List<Salon>? salons,
    List<Category>? categories,
    String? query,
    bool? isLoadingSalons,
    bool? isLoadingMore,
    bool? hasMore,
    bool? loadMoreFailed,
    Category? Function()? selectedCategory,
    int? Function()? highlightedSalonId,
  }) {
    return ExploreLoaded(
      salons: salons ?? this.salons,
      categories: categories ?? this.categories,
      query: query ?? this.query,
      isLoadingSalons: isLoadingSalons ?? this.isLoadingSalons,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
      selectedCategory:
          selectedCategory != null ? selectedCategory() : this.selectedCategory,
      highlightedSalonId: highlightedSalonId != null
          ? highlightedSalonId()
          : this.highlightedSalonId,
      userLat: userLat,
      userLng: userLng,
    );
  }
}

class ExploreError extends ExploreState {
  const ExploreError();
}
