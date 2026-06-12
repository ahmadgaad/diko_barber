import 'package:ronaq_barber/core/shared/domain/entities/salon.dart';

class SalonModel extends Salon {
  const SalonModel({
    required super.id,
    required super.name,
    required super.image,
    required super.averageRating,
    required super.ratingsCount,
    required super.categories,
    required super.isOpen,
    required super.isFavorite,
    required super.lat,
    required super.lng,
    super.location,
    super.distance,
  });

  factory SalonModel.fromJson(Map<String, dynamic> json) {
    final cats = (json['categories'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .map((c) => c['name'] as String)
            .toList() ??
        [];

    return SalonModel(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      averageRating: (json['average_rating'] as num).toDouble(),
      ratingsCount: json['ratings_count'] as int,
      categories: cats,
      isOpen: json['is_open'] as bool,
      isFavorite: json['is_favorite'] as bool,
      lat: double.parse(json['lat'] as String),
      lng: double.parse(json['long'] as String),
      location: json['location'] as String?,
    );
  }
}
