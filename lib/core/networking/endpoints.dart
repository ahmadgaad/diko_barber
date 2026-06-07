abstract final class EndPoints {
  // Auth
  static const String login = 'auth/login';
  static const String register = 'auth/register';
  static const String verifyOtp = 'auth/verify';
  static const String resendOtp = 'auth/resend-otp';
  static const String resendVerification = 'auth/resend-verification';
  static const String logout = 'auth/logout';

  // Onboarding
  static const String onboarding = 'shared/onboarding';

  static String socialLogin(String provider) => 'auth/social/$provider';

  // Shared
  static const String cities = 'shared/cities';
  static const String neighborhoods = 'shared/neighborhoods';
}
