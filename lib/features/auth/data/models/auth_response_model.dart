import 'package:ronaq_barber/features/auth/domain/entities/auth_response.dart';

import 'user_model.dart';

class AuthResponseModel extends AuthResponse {
  const AuthResponseModel({
    required super.user,
    required super.type,
    required super.token,
    required super.emailVerified,
    required super.phoneVerified,
    required super.isVerified,
    required super.hasPassword,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      AuthResponseModel(
        user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
        type: json['type'] as int? ?? 0,
        token: json['token'] as String?,
        emailVerified: json['email_verified'] as bool? ?? false,
        phoneVerified: json['phone_verified'] as bool? ?? false,
        isVerified: json['is_verified'] as bool? ?? false,
        hasPassword: json['has_password'] as bool? ?? false,
      );
}
