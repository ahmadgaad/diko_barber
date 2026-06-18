class ClaimCouponArgs {
  const ClaimCouponArgs({
    required this.couponId,
    required this.salonId,
    required this.couponCode,
    required this.couponName,
    required this.salonName,
  });

  final int couponId;
  final int salonId;
  final String couponCode;
  final String couponName;
  final String salonName;
}
