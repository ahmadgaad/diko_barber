import 'package:zain/core/shared/domain/entities/distance.dart';
import 'package:zain/core/shared/domain/entities/specialization.dart';

class Salon {
  const Salon({
    required this.id,
    required this.name,
    required this.image,
    required this.averageRating,
    required this.ratingsCount,
    required this.categories,
    required this.isOpen,
    required this.isFavorite,
    required this.lat,
    required this.lng,
    required this.specialization,
    this.location,
    this.distance,
    this.withinRadius,
  });

  final int id;
  final String name;
  final String image;
  final double averageRating;
  final int ratingsCount;
  final List<String> categories;
  final bool isOpen;
  final bool isFavorite;
  final double lat;
  final double lng;
  final Specialization specialization;
  final String? location;
  final Distance? distance;
  final bool? withinRadius;

  Salon copyWith({Distance? distance, bool? isFavorite}) {
    return Salon(
      id: id,
      name: name,
      image: image,
      averageRating: averageRating,
      ratingsCount: ratingsCount,
      categories: categories,
      isOpen: isOpen,
      isFavorite: isFavorite ?? this.isFavorite,
      lat: lat,
      lng: lng,
      specialization: specialization,
      location: location,
      distance: distance ?? this.distance,
      withinRadius: withinRadius,
    );
  }
}
