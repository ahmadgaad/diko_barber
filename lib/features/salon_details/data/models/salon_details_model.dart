import 'package:zain/core/shared/domain/entities/coupon.dart';
import 'package:zain/features/salon_details/domain/entities/package.dart';
import 'package:zain/features/salon_details/domain/entities/salon_details.dart';
import 'package:zain/features/salon_details/domain/entities/salon_service.dart';
import 'package:zain/features/salon_details/domain/entities/salon_staff.dart';
import 'package:zain/features/salon_details/domain/entities/shift.dart';

class SalonDetailsModel extends SalonDetails {
  const SalonDetailsModel({
    required super.id,
    required super.name,
    required super.logo,
    required super.coverImage,
    required super.description,
    required super.rating,
    required super.reviewCount,
    required super.distance,
    required super.categories,
    required super.isOpen,
    required super.address,
    required super.gallery,
    required super.services,
    required super.packages,
    required super.reviews,
    required super.coupons,
    required super.staff,
    required super.shifts,
    super.closingTime,
    super.isFavorite,
  });

  factory SalonDetailsModel.fromJson(Map<String, dynamic> json) {
    final image = json['image'] as String? ?? '';
    final distanceJson = json['distance'] as Map<String, dynamic>?;
    final categoriesJson =
        (json['categories'] as List?)?.whereType<Map<String, dynamic>>() ??
            const [];
    final servicesJson =
        (json['services'] as List?)?.whereType<Map<String, dynamic>>() ??
            const [];
    final packagesJson =
        (json['packages'] as List?)?.whereType<Map<String, dynamic>>() ??
            const [];
    final couponsJson =
        (json['coupons'] as List?)?.whereType<Map<String, dynamic>>() ??
            const [];
    final staffJson =
        (json['staff'] as List?)?.whereType<Map<String, dynamic>>() ??
            const [];
    final shiftsJson =
        (json['shifts'] as List?)?.whereType<Map<String, dynamic>>() ??
            const [];

    final couponSalon = CouponSalon(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      image: image,
      location: json['location'] as String?,
    );

    return SalonDetailsModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      logo: image,
      coverImage: image,
      description: json['description'] as String? ?? '',
      rating: _toDouble(json['average_rating']) ?? 0,
      reviewCount: json['ratings_count'] as int? ?? 0,
      distance: distanceJson == null ? 0 : (_toDouble(distanceJson['value']) ?? 0),
      categories: categoriesJson
          .map((c) => c['name'] as String? ?? '')
          .where((name) => name.isNotEmpty)
          .toList(),
      isOpen: json['is_open'] as bool? ?? false,
      isFavorite: json['is_favorite'] as bool? ?? false,
      address: json['location'] as String? ?? '',
      gallery: const [],
      services: servicesJson.map(_parseService).toList(),
      packages: packagesJson.map(_parsePackage).toList(),
      reviews: const [],
      coupons: couponsJson.map((c) => _parseCoupon(c, couponSalon)).toList(),
      staff: staffJson.map(_parseStaff).toList(),
      shifts: shiftsJson.map(_parseShift).toList(),
    );
  }

  static Coupon _parseCoupon(Map<String, dynamic> c, CouponSalon salon) {
    final appliesToJson = c['applies_to'] as Map<String, dynamic>?;
    return Coupon(
      id: c['id'] as int,
      code: c['code'] as String? ?? '',
      name: c['name'] as String? ?? '',
      type: c['type'] as int? ?? 0,
      typeLabel: c['type_label'] as String? ?? '',
      appliesTo: CouponAppliesTo(
        id: appliesToJson?['id'] as int? ?? 0,
        name: appliesToJson?['name'] as String? ?? '',
      ),
      amount: c['amount'] as num? ?? 0,
      maxDiscountAmount: c['max_discount_amount'] as num?,
      startDate: c['start_date'] != null
          ? DateTime.tryParse(c['start_date'] as String)
          : null,
      endDate: DateTime.tryParse(c['end_date'] as String? ?? '') ??
          DateTime.now(),
      remainingUsage: c['remaining_usage'] as int?,
      salon: salon,
    );
  }

  static SalonStaff _parseStaff(Map<String, dynamic> s) {
    return SalonStaff(
      id: s['id'] as int,
      name: s['name'] as String? ?? '',
      image: s['image'] as String? ?? '',
      rating: _toDouble(s['average_rating']) ?? 0,
      ratingsCount: s['ratings_count'] as int? ?? 0,
    );
  }

  static Shift _parseShift(Map<String, dynamic> s) {
    return Shift(
      id: s['id'] as int,
      dayWeek: s['day_week'] as int? ?? 0,
      dayName: s['day_name'] as String? ?? '',
      from: s['from'] as String? ?? '',
      to: s['to'] as String? ?? '',
      isActive: s['is_active'] as bool? ?? false,
    );
  }

  static SalonService _parseService(Map<String, dynamic> s) {
    return SalonService(
      id: s['id'] as int,
      name: s['name'] as String? ?? '',
      description: s['category_name'] as String? ?? '',
      image: s['image'] as String? ?? '',
      price: _toDouble(s['discounted_price'] ?? s['price']) ?? 0,
      durationMinutes: s['duration_minutes'] as int? ?? 0,
      rating: 0,
      isFavorite: s['is_favorite'] as bool? ?? false,
    );
  }

  static Package _parsePackage(Map<String, dynamic> p) {
    final servicesJson =
        (p['services'] as List?)?.whereType<Map<String, dynamic>>() ??
            const [];
    return Package(
      id: p['id'] as int,
      name: p['name'] as String? ?? '',
      description: p['description'] as String? ?? '',
      image: p['image'] as String? ?? '',
      price: _toDouble(p['discounted_price'] ?? p['price']) ?? 0,
      rating: 0,
      services: servicesJson.map(_parseService).toList(),
      isFavorite: p['is_favorite'] as bool? ?? false,
    );
  }

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }
}
