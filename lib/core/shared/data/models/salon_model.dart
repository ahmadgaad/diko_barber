import 'package:ronaq_barber/core/shared/domain/entities/distance.dart';
import 'package:ronaq_barber/core/shared/domain/entities/salon.dart';
import 'package:ronaq_barber/core/shared/domain/entities/specialization.dart';

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
    required super.specialization,
    super.location,
    super.distance,
    super.withinRadius,
  });

  factory SalonModel.fromJson(Map<String, dynamic> json) {
    final cats = (json['categories'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .map((c) => c['name'] as String)
            .toList() ??
        [];

    final spec = json['specialization'] as Map<String, dynamic>;

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
      specialization: Specialization(
        id: spec['id'] as int,
        name: spec['name'] as String,
      ),
      location: json['location'] as String?,
      distance: json['distance'] == null
          ? null
          : Distance(
              value: json['distance']['value'] as num,
              unit: json['distance']['unit'] as String,
            ),
      withinRadius: json['within_radius'] as bool?,
    );
  }
}
