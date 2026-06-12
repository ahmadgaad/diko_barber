import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/features/onboarding/domain/entities/onboarding_item.dart';
import 'package:ronaq_barber/features/onboarding/domain/repositories/onboarding_repository.dart';

class GetOnboardingUseCase {
  const GetOnboardingUseCase(this._repository);

  final OnboardingRepository _repository;

  Future<Result<ApiErrorModel, List<OnboardingItem>>> call() =>
      _repository.getItems();
}
