import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/features/salon_auth/domain/entities/salon_register_params.dart';
import 'package:ronaq_barber/features/salon_auth/domain/repositories/salon_auth_repository.dart';

class SalonRegisterUseCase {
  const SalonRegisterUseCase(this._repository);

  final SalonAuthRepository _repository;

  Future<Result<ApiErrorModel, void>> call(SalonRegisterParams params) =>
      _repository.register(params);
}
