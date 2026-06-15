class CouponEligiblePackage {
  const CouponEligiblePackage({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.discountedPrice,
    required this.durationMinutes,
    required this.salonId,
    required this.salonName,
    required this.salonImage,
    this.specializationName,
    this.savings,
  });

  final int id;
  final String name;
  final String description;
  final String image;
  final num price;
  final num discountedPrice;
  final int durationMinutes;
  final int salonId;
  final String salonName;
  final String salonImage;
  final String? specializationName;
  final num? savings;

  bool get hasDiscount => discountedPrice < price;
  num get effectivePrice => discountedPrice;
}
