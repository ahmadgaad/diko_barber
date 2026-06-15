import 'package:zain/core/shared/domain/entities/distance.dart';

class ServiceDiscount {
  const ServiceDiscount({required this.type, required this.value});
  final String type;
  final num value;
}

class ServiceSalon {
  const ServiceSalon({
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

class NearestService {
  const NearestService({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.durationMinutes,
    required this.salon,
    this.categoryId,
    this.categoryName,
    this.discountedPrice,
    this.discount,
    this.requiresConsultation = false,
    this.distance,
    this.withinRadius,
    this.isFavorite = false,
  });

  final int id;
  final String name;
  final String image;
  final num price;
  final int durationMinutes;
  final ServiceSalon salon;
  final int? categoryId;
  final String? categoryName;
  final num? discountedPrice;
  final ServiceDiscount? discount;
  final bool requiresConsultation;
  final Distance? distance;
  final bool? withinRadius;
  final bool isFavorite;

  num get effectivePrice => discountedPrice ?? price;
  bool get hasDiscount => discountedPrice != null && discountedPrice! < price;

  NearestService copyWith({bool? isFavorite}) => NearestService(
        id: id,
        name: name,
        image: image,
        price: price,
        durationMinutes: durationMinutes,
        salon: salon,
        categoryId: categoryId,
        categoryName: categoryName,
        discountedPrice: discountedPrice,
        discount: discount,
        requiresConsultation: requiresConsultation,
        distance: distance,
        withinRadius: withinRadius,
        isFavorite: isFavorite ?? this.isFavorite,
      );
}
