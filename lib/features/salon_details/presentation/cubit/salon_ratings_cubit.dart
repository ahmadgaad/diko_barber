import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/features/salon_details/domain/entities/review.dart';
import 'package:ronaq_barber/features/salon_details/domain/use_cases/get_salon_ratings_use_case.dart';
import 'package:ronaq_barber/features/salon_details/presentation/cubit/salon_ratings_state.dart';

class SalonRatingsCubit extends Cubit<SalonRatingsState> {
  SalonRatingsCubit(this._getSalonRatings) : super(const SalonRatingsLoading());

  final GetSalonRatingsUseCase _getSalonRatings;

  static const _perPage = 15;

  int _salonId = 0;
  int _currentPage = 1;
  bool _hasMore = false;

  Future<void> load(int salonId) async {
    _salonId = salonId;
    _currentPage = 1;
    emit(const SalonRatingsLoading());

    final result = await _getSalonRatings(_salonId, page: _currentPage, perPage: _perPage);
    if (isClosed) return;

    result.when(
      failure: (_) => emit(const SalonRatingsError()),
      success: (page) {
        _hasMore = page.hasMore;
        emit(SalonRatingsLoaded(
          stats: page.stats,
          ratings: page.ratings,
          hasMore: _hasMore,
        ));
      },
    );
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    final current = state;
    if (current is! SalonRatingsLoaded || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));
    _currentPage++;

    final result = await _getSalonRatings(_salonId, page: _currentPage, perPage: _perPage);
    if (isClosed) return;

    result.when(
      failure: (_) {
        _currentPage--;
        emit(current.copyWith(isLoadingMore: false));
      },
      success: (page) {
        _hasMore = page.hasMore;
        emit(SalonRatingsLoaded(
          stats: page.stats,
          ratings: <Review>[...current.ratings, ...page.ratings],
          hasMore: _hasMore,
        ));
      },
    );
  }
}
