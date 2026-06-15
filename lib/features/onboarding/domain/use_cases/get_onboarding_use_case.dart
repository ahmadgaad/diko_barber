import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/onboarding/domain/entities/onboarding_item.dart';
import 'package:zain/features/onboarding/domain/repositories/onboarding_repository.dart';

class GetOnboardingUseCase {
  const GetOnboardingUseCase(this._repository);

  final OnboardingRepository _repository;

  Future<Result<ApiErrorModel, List<OnboardingItem>>> call() =>
      _repository.getItems();
}
