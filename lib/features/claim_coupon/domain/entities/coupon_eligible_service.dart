class CouponEligibleService {
  const CouponEligibleService({
    required this.id,
    required this.name,
    required this.image,
    required this.categoryName,
    required this.price,
    required this.discountedPrice,
    required this.durationMinutes,
    required this.salonId,
    required this.salonName,
    required this.salonImage,
  });

  final int id;
  final String name;
  final String image;
  final String categoryName;
  final num price;
  final num discountedPrice;
  final int durationMinutes;
  final int salonId;
  final String salonName;
  final String salonImage;

  bool get hasDiscount => discountedPrice < price;
  num get effectivePrice => discountedPrice;
}
