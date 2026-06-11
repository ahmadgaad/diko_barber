import 'package:ronaq_barber/core/shared/domain/entities/package.dart';
import 'package:ronaq_barber/core/shared/domain/entities/review.dart';
import 'package:ronaq_barber/core/shared/domain/entities/salon_service.dart';

class SalonDetails {
  const SalonDetails({
    required this.id,
    required this.name,
    required this.logo,
    required this.coverImage,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.categories,
    required this.isOpen,
    required this.address,
    required this.gallery,
    required this.services,
    required this.packages,
    required this.reviews,
    this.closingTime,
    this.isFavorite = false,
  });

  final int id;
  final String name;
  final String logo;
  final String coverImage;
  final String description;
  final double rating;
  final int reviewCount;
  final double distance;
  final List<String> categories;
  final bool isOpen;
  final String? closingTime;
  final bool isFavorite;
  final String address;
  final List<String> gallery;
  final List<SalonService> services;
  final List<Package> packages;
  final List<Review> reviews;
}
