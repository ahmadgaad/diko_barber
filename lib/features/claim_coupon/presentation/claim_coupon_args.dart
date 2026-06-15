class ClaimCouponArgs {
  const ClaimCouponArgs({
    required this.couponId,
    required this.couponCode,
    required this.couponName,
    required this.salonName,
  });

  final int couponId;
  final String couponCode;
  final String couponName;
  final String salonName;
}
