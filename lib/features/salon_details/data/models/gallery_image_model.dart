import 'package:ronaq_barber/features/salon_details/domain/entities/gallery_image.dart';

class GalleryImageModel extends GalleryImage {
  const GalleryImageModel({
    required super.id,
    required super.title,
    required super.url,
  });

  factory GalleryImageModel.fromJson(Map<String, dynamic> json) {
    return GalleryImageModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }
}
