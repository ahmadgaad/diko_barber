abstract final class EndPoints {
  // Auth
  static const String login = 'auth/login';
  static const String register = 'auth/register';
  static const String verifyOtp = 'auth/verify';
  static const String resendOtp = 'auth/resend-otp';
  static const String resendVerification = 'auth/resend-verification';
  static const String logout = 'auth/logout';
  static const String forgotPassword = 'auth/forgot-password';
  static const String verifyResetPassword = 'auth/verify-reset-password';
  static const String resetPassword = 'auth/reset-password';

  // Onboarding
  static const String onboarding = 'shared/onboarding';

  static String socialLogin(String provider) => 'auth/social/$provider';

  // Shared
  static const String cities = 'shared/cities';
  static const String neighborhoods = 'shared/neighborhoods';
  static const String categories = 'shared/categories';
  static const String banners = 'shared/banners';

  // User
  static const String nearestSalons = 'user/nearest-salons';
  static const String nearestCoupons = 'user/nearest-coupons';
  static const String nearestPackages = 'user/nearest-packages';
  static const String nearestServices = 'user/nearest-services';
  static String packageDetails(int id) => 'user/package/$id';
  static String salonDetails(int id) => 'user/salon/$id';
  static String salonGallery(int id) => 'user/salon/$id/gallery';
  static String salonRatings(int id) => 'user/salon/$id/ratings';
  static String salonServices(int id) => 'user/salons/$id/services';
  static String salonStaff(int id) => 'user/salons/$id/staff';
  static String salonSlots(int id) => 'user/salons/$id/slots';
  static const String validateCoupon = 'user/coupons/validate';
  static const String createBooking = 'user/bookings';
  static const String toggleFavorite = 'user/toggle-favorite';
  static const String favorites = 'user/favorites';
  static const String couponServicesAndPackages = 'user/coupon/services-and-packages';

  // Salon Auth
  static const String salonRegister = 'salon-auth/register';
  static const String salonVerifyOtp = 'salon-auth/verify-otp';
  static const String salonResendOtp = 'salon-auth/resend-otp';
}
