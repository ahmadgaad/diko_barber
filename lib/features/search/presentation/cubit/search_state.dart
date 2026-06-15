import 'package:zain/core/shared/domain/entities/coupon.dart';
import 'package:zain/core/shared/domain/entities/salon.dart';

sealed class SearchState {
  const SearchState();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchIdle extends SearchState {
  const SearchIdle({
    required this.recentSalons,
    required this.trendingSalons,
    required this.hotOffers,
  });

  final List<Salon> recentSalons;
  final List<Salon> trendingSalons;
  final List<Coupon> hotOffers;
}

class SearchActive extends SearchState {
  const SearchActive({
    required this.query,
    required this.results,
  });

  final String query;
  final List<Salon> results;
}
