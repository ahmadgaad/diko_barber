import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/auth/domain/entities/auth_response.dart';

import '../repositories/auth_repository.dart';

class SocialLoginUseCase {
  const SocialLoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<ApiErrorModel, AuthResponse>> call({
    required String provider,
    required String accessToken,
    String? idToken,
    String? fcmToken,
  }) =>
      _repository.socialLogin(
        provider: provider,
        accessToken: accessToken,
        idToken: idToken,
        fcmToken: fcmToken,
      );
}
