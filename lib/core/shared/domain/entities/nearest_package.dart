import 'package:zain/core/shared/domain/entities/distance.dart';

class PackageDiscount {
  const PackageDiscount({required this.type, required this.value});
  final String type;
  final num value;
}

class PackageSpecialization {
  const PackageSpecialization({required this.id, required this.name});
  final int id;
  final String name;
}

class PackageSalon {
  const PackageSalon({
    required this.id,
    required this.name,
    required this.image,
    this.lat,
    this.long,
    this.location,
    this.distance,
    this.withinRadius,
  });
  final int id;
  final String name;
  final String image;
  final double? lat;
  final double? long;
  final String? location;
  final Distance? distance;
  final bool? withinRadius;
}

class NearestPackage {
  const NearestPackage({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.durationMinutes,
    required this.salon,
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
  final num? discountedPrice;
  final PackageDiscount? discount;
  final PackageSpecialization? specialization;
  final num? servicesTotalPrice;
  final num? savings;
  final Distance? distance;
  final bool? withinRadius;
  final bool isFavorite;

  num get effectivePrice => discountedPrice ?? price;
  bool get hasDiscount => discountedPrice != null && discountedPrice! < price;

  NearestPackage copyWith({bool? isFavorite}) => NearestPackage(
        id: id,
        name: name,
        description: description,
        image: image,
        price: price,
        durationMinutes: durationMinutes,
        salon: salon,
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
