import 'package:zain/features/salon_details/domain/entities/gallery_image.dart';

sealed class SalonGalleryState {
  const SalonGalleryState();
}

class SalonGalleryLoading extends SalonGalleryState {
  const SalonGalleryLoading();
}

class SalonGalleryLoaded extends SalonGalleryState {
  const SalonGalleryLoaded({
    required this.images,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  final List<GalleryImage> images;
  final bool hasMore;
  final bool isLoadingMore;

  SalonGalleryLoaded copyWith({
    List<GalleryImage>? images,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return SalonGalleryLoaded(
      images: images ?? this.images,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class SalonGalleryError extends SalonGalleryState {
  const SalonGalleryError();
}
