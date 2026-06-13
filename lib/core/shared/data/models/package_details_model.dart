import 'package:ronaq_barber/core/shared/domain/entities/distance.dart';
import 'package:ronaq_barber/core/shared/domain/entities/nearest_package.dart';
import 'package:ronaq_barber/core/shared/domain/entities/package_details.dart';

class PackageDetailsModel extends PackageDetails {
  const PackageDetailsModel({
    required super.id,
    required super.name,
    required super.description,
    required super.image,
    required super.price,
    required super.durationMinutes,
    required super.salon,
    required super.services,
    super.discountedPrice,
    super.discount,
    super.specialization,
    super.servicesTotalPrice,
    super.savings,
    super.distance,
    super.withinRadius,
  });

  factory PackageDetailsModel.fromJson(Map<String, dynamic> json) {
    final discountJson = json['discount'] as Map<String, dynamic>?;
    final specJson = json['specialization'] as Map<String, dynamic>?;
    final salonJson = json['salon'] as Map<String, dynamic>? ?? {};
    final distanceJson = json['distance'] as Map<String, dynamic>?;
    final salonDistanceJson = salonJson['distance'] as Map<String, dynamic>?;
    final servicesJson =
        (json['services'] as List?)?.whereType<Map<String, dynamic>>().toList() ??
            [];

    return PackageDetailsModel(
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
      services: servicesJson
          .map(_parseServiceItem)
          .toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)),
      distance: distanceJson == null
          ? null
          : Distance(
              value: _toNum(distanceJson['value']) ?? 0,
              unit: distanceJson['unit'] as String,
            ),
      withinRadius: json['within_radius'] as bool?,
    );
  }

  static PackageServiceItem _parseServiceItem(Map<String, dynamic> s) {
    final discountJson = s['discount'] as Map<String, dynamic>?;
    return PackageServiceItem(
      id: s['id'] as int,
      name: s['name'] as String,
      image: s['image'] as String? ?? '',
      categoryId: s['category_id'] as int? ?? 0,
      categoryName: s['category_name'] as String? ?? '',
      price: _toNum(s['price']) ?? 0,
      discountedPrice: _toNum(s['discounted_price']),
      discount: discountJson == null
          ? null
          : PackageDiscount(
              type: discountJson['type'] as String,
              value: _toNum(discountJson['value']) ?? 0,
            ),
      durationMinutes: s['duration_minutes'] as int? ?? 0,
      requiresConsultation: s['requires_consultation'] as bool? ?? false,
      sortOrder: s['sort_order'] as int? ?? 0,
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
