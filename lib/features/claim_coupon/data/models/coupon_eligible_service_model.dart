import '../../domain/entities/coupon_eligible_service.dart';

class CouponEligibleServiceModel extends CouponEligibleService {
  const CouponEligibleServiceModel({
    required super.id,
    required super.name,
    required super.image,
    required super.categoryName,
    required super.price,
    required super.discountedPrice,
    required super.durationMinutes,
    required super.salonId,
    required super.salonName,
    required super.salonImage,
  });

  factory CouponEligibleServiceModel.fromJson(Map<String, dynamic> json) {
    final salon = json['salon'] as Map<String, dynamic>;
    return CouponEligibleServiceModel(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      categoryName: json['category_name'] as String,
      price: json['price'] as num,
      discountedPrice: (json['discounted_price'] as num?) ?? json['price'] as num,
      durationMinutes: json['duration_minutes'] as int,
      salonId: salon['id'] as int,
      salonName: salon['name'] as String,
      salonImage: salon['image'] as String,
    );
  }
}
