import 'package:equatable/equatable.dart';
import 'package:ronaq_barber/features/salon_details/domain/entities/rating_stats.dart';
import 'package:ronaq_barber/features/salon_details/domain/entities/review.dart';

class SalonRatingsPage extends Equatable {
  const SalonRatingsPage({
    required this.stats,
    required this.ratings,
    required this.hasMore,
  });

  final RatingStats stats;
  final List<Review> ratings;
  final bool hasMore;

  @override
  List<Object?> get props => [stats, ratings, hasMore];
}
