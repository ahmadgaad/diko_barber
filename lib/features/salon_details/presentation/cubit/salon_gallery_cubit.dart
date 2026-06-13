import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/features/salon_details/domain/entities/gallery_image.dart';
import 'package:ronaq_barber/features/salon_details/domain/use_cases/get_salon_gallery_use_case.dart';
import 'package:ronaq_barber/features/salon_details/presentation/cubit/salon_gallery_state.dart';

class SalonGalleryCubit extends Cubit<SalonGalleryState> {
  SalonGalleryCubit(this._getSalonGallery)
      : super(const SalonGalleryLoading());

  final GetSalonGalleryUseCase _getSalonGallery;

  static const _perPage = 15;

  int _salonId = 0;
  int _currentPage = 1;
  bool _hasMore = false;

  Future<void> load(int salonId) async {
    _salonId = salonId;
    _currentPage = 1;
    emit(const SalonGalleryLoading());

    final result = await _getSalonGallery(
      _salonId,
      page: _currentPage,
      perPage: _perPage,
    );
    if (isClosed) return;

    result.when(
      failure: (_) => emit(const SalonGalleryError()),
      success: (page) {
        _hasMore = page.hasMore;
        emit(SalonGalleryLoaded(images: page.images, hasMore: _hasMore));
      },
    );
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    final current = state;
    if (current is! SalonGalleryLoaded || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));
    _currentPage++;

    final result = await _getSalonGallery(
      _salonId,
      page: _currentPage,
      perPage: _perPage,
    );
    if (isClosed) return;

    result.when(
      failure: (_) {
        _currentPage--;
        emit(current.copyWith(isLoadingMore: false));
      },
      success: (page) {
        _hasMore = page.hasMore;
        emit(SalonGalleryLoaded(
          images: <GalleryImage>[...current.images, ...page.images],
          hasMore: _hasMore,
        ));
      },
    );
  }
}
