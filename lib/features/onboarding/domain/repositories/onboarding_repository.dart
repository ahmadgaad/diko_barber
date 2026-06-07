import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/features/onboarding/domain/entities/onboarding_item.dart';

abstract interface class OnboardingRepository {
  Future<bool> hasSeenOnboarding();
  Future<void> markOnboardingSeen();
  Future<Result<ApiErrorModel, List<OnboardingItem>>> getItems();
}
