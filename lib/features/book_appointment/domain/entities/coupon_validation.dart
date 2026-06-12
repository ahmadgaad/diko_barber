class CouponValidation {
  const CouponValidation({
    required this.isValid,
    required this.discountAmount,
    required this.discountType,
    this.message,
  });

  final bool isValid;
  final num discountAmount;
  final String discountType;
  final String? message;
}
