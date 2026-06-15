import 'package:zain/features/salon_details/domain/entities/rating_stats.dart';
import 'package:zain/features/salon_details/domain/entities/review.dart';

sealed class SalonRatingsState {
  const SalonRatingsState();
}

class SalonRatingsLoading extends SalonRatingsState {
  const SalonRatingsLoading();
}

class SalonRatingsLoaded extends SalonRatingsState {
  const SalonRatingsLoaded({
    required this.stats,
    required this.ratings,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  final RatingStats stats;
  final List<Review> ratings;
  final bool hasMore;
  final bool isLoadingMore;

  SalonRatingsLoaded copyWith({
    RatingStats? stats,
    List<Review>? ratings,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return SalonRatingsLoaded(
      stats: stats ?? this.stats,
      ratings: ratings ?? this.ratings,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class SalonRatingsError extends SalonRatingsState {
  const SalonRatingsError();
}
