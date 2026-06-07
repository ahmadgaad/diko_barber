import 'user.dart';

class AuthResponse {
  final User user;
  final int type;
  final String? token;
  final bool emailVerified;
  final bool phoneVerified;
  final bool isVerified;
  final bool hasPassword;

  const AuthResponse({
    required this.user,
    required this.type,
    this.token,
    required this.emailVerified,
    required this.phoneVerified,
    required this.isVerified,
    required this.hasPassword,
  });
}
