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

  // Salon Auth
  static const String salonRegister = 'salon-auth/register';
  static const String salonVerifyOtp = 'salon-auth/verify-otp';
  static const String salonResendOtp = 'salon-auth/resend-otp';
}
