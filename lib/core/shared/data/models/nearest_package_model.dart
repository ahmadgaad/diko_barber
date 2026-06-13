import 'package:ronaq_barber/core/shared/domain/entities/distance.dart';
import 'package:ronaq_barber/core/shared/domain/entities/nearest_package.dart';

class NearestPackageModel extends NearestPackage {
  const NearestPackageModel({
    required super.id,
    required super.name,
    required super.description,
    required super.image,
    required super.price,
    required super.durationMinutes,
    required super.salon,
    super.discountedPrice,
    super.discount,
    super.specialization,
    super.servicesTotalPrice,
    super.savings,
    super.distance,
    super.withinRadius,
    super.isFavorite,
  });

  factory NearestPackageModel.fromJson(Map<String, dynamic> json) {
    final discountJson = json['discount'] as Map<String, dynamic>?;
    final specJson = json['specialization'] as Map<String, dynamic>?;
    final salonJson = json['salon'] as Map<String, dynamic>? ?? {};
    final distanceJson = json['distance'] as Map<String, dynamic>?;
    final salonDistanceJson = salonJson['distance'] as Map<String, dynamic>?;

    return NearestPackageModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
      price: _toNum(json['price']) ?? 0,
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      discountedPrice: _toNum(json['discounted_price']),
      discount: discountJson == null
          ? null
          : PackageDiscount(
              type: discountJson['type'] as String,
              value: _toNum(discountJson['value']) ?? 0,
            ),
      specialization: specJson == null
          ? null
          : PackageSpecialization(
              id: specJson['id'] as int,
              name: specJson['name'] as String,
            ),
      servicesTotalPrice: _toNum(json['services_total_price']),
      savings: _toNum(json['savings']),
      salon: PackageSalon(
        id: salonJson['id'] as int? ?? 0,
        name: salonJson['name'] as String? ?? '',
        image: salonJson['image'] as String? ?? '',
        lat: _toDouble(salonJson['lat']),
        long: _toDouble(salonJson['long']),
        location: salonJson['location'] as String?,
        distance: salonDistanceJson == null
            ? null
            : Distance(
                value: _toNum(salonDistanceJson['value']) ?? 0,
                unit: salonDistanceJson['unit'] as String,
              ),
        withinRadius: salonJson['within_radius'] as bool?,
      ),
      distance: distanceJson == null
          ? null
          : Distance(
              value: _toNum(distanceJson['value']) ?? 0,
              unit: distanceJson['unit'] as String,
            ),
      withinRadius: json['within_radius'] as bool?,
      isFavorite: json['is_favorite'] as bool? ?? false,
    );
  }

  static num? _toNum(dynamic v) {
    if (v == null) return null;
    if (v is num) return v;
    if (v is String) return num.tryParse(v);
    return null;
  }

  static double? _toDouble(dynamic v) => _toNum(v)?.toDouble();
}
