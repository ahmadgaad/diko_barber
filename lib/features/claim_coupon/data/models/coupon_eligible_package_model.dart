import '../../domain/entities/coupon_eligible_package.dart';

class CouponEligiblePackageModel extends CouponEligiblePackage {
  const CouponEligiblePackageModel({
    required super.id,
    required super.name,
    required super.description,
    required super.image,
    required super.price,
    required super.discountedPrice,
    required super.durationMinutes,
    required super.salonId,
    required super.salonName,
    required super.salonImage,
    super.specializationName,
    super.savings,
  });

  factory CouponEligiblePackageModel.fromJson(Map<String, dynamic> json) {
    final salon = json['salon'] as Map<String, dynamic>;
    final spec = json['specialization'] as Map<String, dynamic>?;
    return CouponEligiblePackageModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      price: json['price'] as num,
      discountedPrice: (json['discounted_price'] as num?) ?? json['price'] as num,
      durationMinutes: json['duration_minutes'] as int,
      salonId: salon['id'] as int,
      salonName: salon['name'] as String,
      salonImage: salon['image'] as String,
      specializationName: spec?['name'] as String?,
      savings: json['savings'] as num?,
    );
  }
}
