import 'package:zain/core/shared/domain/entities/distance.dart';
import 'package:zain/core/shared/domain/entities/nearest_package.dart';

class PackageServiceItem {
  const PackageServiceItem({
    required this.id,
    required this.name,
    required this.image,
    required this.categoryId,
    required this.categoryName,
    required this.price,
    required this.durationMinutes,
    required this.requiresConsultation,
    required this.sortOrder,
    this.discountedPrice,
    this.discount,
  });

  final int id;
  final String name;
  final String image;
  final int categoryId;
  final String categoryName;
  final num price;
  final int durationMinutes;
  final bool requiresConsultation;
  final int sortOrder;
  final num? discountedPrice;
  final PackageDiscount? discount;

  num get effectivePrice => discountedPrice ?? price;
  bool get hasDiscount =>
      discountedPrice != null && discountedPrice! < price;
}

class PackageDetails {
  const PackageDetails({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.durationMinutes,
    required this.salon,
    required this.services,
    this.discountedPrice,
    this.discount,
    this.specialization,
    this.servicesTotalPrice,
    this.savings,
    this.distance,
    this.withinRadius,
    this.isFavorite = false,
  });

  final int id;
  final String name;
  final String description;
  final String image;
  final num price;
  final int durationMinutes;
  final PackageSalon salon;
  final List<PackageServiceItem> services;
  final num? discountedPrice;
  final PackageDiscount? discount;
  final PackageSpecialization? specialization;
  final num? servicesTotalPrice;
  final num? savings;
  final Distance? distance;
  final bool? withinRadius;
  final bool isFavorite;

  num get effectivePrice => discountedPrice ?? price;
  bool get hasDiscount =>
      discountedPrice != null && discountedPrice! < price;

  PackageDetails copyWith({bool? isFavorite}) => PackageDetails(
        id: id,
        name: name,
        description: description,
        image: image,
        price: price,
        durationMinutes: durationMinutes,
        salon: salon,
        services: services,
        discountedPrice: discountedPrice,
        discount: discount,
        specialization: specialization,
        servicesTotalPrice: servicesTotalPrice,
        savings: savings,
        distance: distance,
        withinRadius: withinRadius,
        isFavorite: isFavorite ?? this.isFavorite,
      );
}
