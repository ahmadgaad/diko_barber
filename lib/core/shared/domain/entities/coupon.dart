class Coupon {
  const Coupon({
    required this.id,
    required this.code,
    required this.discountPercent,
    required this.serviceLabel,
    required this.salonName,
    required this.salonLogo,
    required this.expiresAt,
  });

  final int id;
  final String code;
  final int discountPercent;
  final String serviceLabel;
  final String salonName;
  final String salonLogo;
  final DateTime expiresAt;
}
