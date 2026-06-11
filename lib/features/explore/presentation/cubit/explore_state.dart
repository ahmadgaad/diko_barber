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
  });

  /// Salons after applying [query] and [selectedCategory] filters.
  final List<Salon> salons;

  /// All available category filter chips.
  final List<String> categories;

  final String query;

  /// `null` means "All".
  final String? selectedCategory;

  /// The salon whose map pin is currently highlighted (tapped).
  final int? highlightedSalonId;

  ExploreLoaded copyWith({
    List<Salon>? salons,
    List<String>? categories,
    String? query,
    String? Function()? selectedCategory,
    int? Function()? highlightedSalonId,
  }) {
    return ExploreLoaded(
      salons: salons ?? this.salons,
      categories: categories ?? this.categories,
      query: query ?? this.query,
      selectedCategory: selectedCategory != null
          ? selectedCategory()
          : this.selectedCategory,
      highlightedSalonId: highlightedSalonId != null
          ? highlightedSalonId()
          : this.highlightedSalonId,
    );
  }
}

class ExploreError extends ExploreState {
  const ExploreError();
}
