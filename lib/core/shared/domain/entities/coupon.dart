import 'package:zain/core/shared/domain/entities/distance.dart';

class CouponAppliesTo {
  const CouponAppliesTo({required this.id, required this.name});
  final int id;
  final String name;
}

class CouponSalon {
  const CouponSalon({
    required this.id,
    required this.name,
    required this.image,
    this.location,
    this.distance,
    this.withinRadius,
  });
  final int id;
  final String name;
  final String image;
  final String? location;
  final Distance? distance;
  final bool? withinRadius;
}

class Coupon {
  const Coupon({
    required this.id,
    required this.code,
    required this.name,
    required this.type,
    required this.typeLabel,
    required this.appliesTo,
    required this.amount,
    required this.endDate,
    required this.salon,
    this.maxDiscountAmount,
    this.startDate,
    this.remainingUsage,
    this.distance,
    this.withinRadius,
  });

  final int id;
  final String code;
  final String name;
  final int type;
  final String typeLabel;
  final CouponAppliesTo appliesTo;
  final num amount;
  final DateTime endDate;
  final CouponSalon salon;
  final num? maxDiscountAmount;
  final DateTime? startDate;
  final int? remainingUsage;
  final Distance? distance;
  final bool? withinRadius;

  bool get isPercentage => type == 1;
}
