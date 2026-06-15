import 'package:zain/core/shared/domain/entities/coupon.dart';
import 'package:zain/core/shared/domain/entities/distance.dart';

class CouponModel extends Coupon {
  const CouponModel({
    required super.id,
    required super.code,
    required super.name,
    required super.type,
    required super.typeLabel,
    required super.appliesTo,
    required super.amount,
    required super.endDate,
    required super.salon,
    super.maxDiscountAmount,
    super.startDate,
    super.remainingUsage,
    super.distance,
    super.withinRadius,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    final appliesToJson = json['applies_to'] as Map<String, dynamic>;
    final salonJson = json['salon'] as Map<String, dynamic>;
    final distanceJson = json['distance'] as Map<String, dynamic>?;
    final salonDistanceJson = salonJson['distance'] as Map<String, dynamic>?;

    return CouponModel(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String,
      type: json['type'] as int,
      typeLabel: json['type_label'] as String,
      appliesTo: CouponAppliesTo(
        id: appliesToJson['id'] as int,
        name: appliesToJson['name'] as String,
      ),
      amount: json['amount'] as num,
      maxDiscountAmount: json['max_discount_amount'] as num?,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : null,
      endDate: DateTime.parse(json['end_date'] as String),
      remainingUsage: json['remaining_usage'] as int?,
      salon: CouponSalon(
        id: salonJson['id'] as int,
        name: salonJson['name'] as String,
        image: salonJson['image'] as String,
        location: salonJson['location'] as String?,
        distance: salonDistanceJson == null
            ? null
            : Distance(
                value: salonDistanceJson['value'] as num,
                unit: salonDistanceJson['unit'] as String,
              ),
        withinRadius: salonJson['within_radius'] as bool?,
      ),
      distance: distanceJson == null
          ? null
          : Distance(
              value: distanceJson['value'] as num,
              unit: distanceJson['unit'] as String,
            ),
      withinRadius: json['within_radius'] as bool?,
    );
  }
}
