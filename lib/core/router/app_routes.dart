abstract final class AppRoutes {
  static const splash = '/splash';
  static const home = '/';
  static const explore = '/explore';
  static const bookings = '/bookings';
  static const favorites = '/favorites';
  static const profile = '/profile';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const signup = '/signup';
  static const verifyOtp = '/verify-otp';
  static const forgotPassword = '/forgot-password';
  static const verifyResetPassword = '/verify-reset-password';
  static const resetPassword = '/reset-password';

  static const search = '/search';
  static const salonDetails = '/salon/:id';
  static const exploreMap = '/explore-map';

  static const bookAppointment = '/book-appointment';
  static const packageDetails = '/package/:id';
  static const packagesList = '/packages';

  static const claimCoupon = '/claim-coupon';
  static const bookingSchedule = '/booking-schedule';

  static const checkout = '/checkout';
  static const bookingDetails = '/booking-details';
  static const paymentWebview = '/payment-webview';

  // Salon Auth
  static const salonSignup = '/salon-signup';
  static const salonVerifyOtp = '/salon-verify-otp';
  static const salonRegisterSuccess = '/salon-register-success';
}
