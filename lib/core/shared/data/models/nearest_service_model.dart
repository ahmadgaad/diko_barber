import 'package:ronaq_barber/core/shared/domain/entities/distance.dart';
import 'package:ronaq_barber/core/shared/domain/entities/nearest_service.dart';

class NearestServiceModel extends NearestService {
  const NearestServiceModel({
    required super.id,
    required super.name,
    required super.image,
    required super.price,
    required super.durationMinutes,
    required super.salon,
    super.categoryId,
    super.categoryName,
    super.discountedPrice,
    super.discount,
    super.requiresConsultation,
    super.distance,
    super.withinRadius,
    super.isFavorite,
  });

  factory NearestServiceModel.fromJson(Map<String, dynamic> json) {
    final discountJson = json['discount'] as Map<String, dynamic>?;
    final salonJson = json['salon'] as Map<String, dynamic>? ?? {};
    final distanceJson = json['distance'] as Map<String, dynamic>?;
    final salonDistanceJson = salonJson['distance'] as Map<String, dynamic>?;

    return NearestServiceModel(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String? ?? '',
      price: _toNum(json['price']) ?? 0,
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      categoryId: json['category_id'] as int?,
      categoryName: json['category_name'] as String?,
      discountedPrice: _toNum(json['discounted_price']),
      discount: discountJson == null
          ? null
          : ServiceDiscount(
              type: discountJson['type'] as String,
              value: _toNum(discountJson['value']) ?? 0,
            ),
      requiresConsultation: json['requires_consultation'] as bool? ?? false,
      salon: ServiceSalon(
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
