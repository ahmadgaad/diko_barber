import 'package:equatable/equatable.dart';

import 'gallery_image.dart';

class SalonGalleryPage extends Equatable {
  const SalonGalleryPage({required this.images, required this.hasMore});

  final List<GalleryImage> images;
  final bool hasMore;

  @override
  List<Object?> get props => [images, hasMore];
}
