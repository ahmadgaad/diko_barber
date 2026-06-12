class SalonDetailsArgs {
  const SalonDetailsArgs({this.couponCode, this.initialTab = 0});

  final String? couponCode;
  final int initialTab; // 0 = services, 1 = packages
}
