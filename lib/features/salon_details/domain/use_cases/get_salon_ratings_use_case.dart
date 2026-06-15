import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/salon_details/domain/entities/salon_ratings_page.dart';
import 'package:zain/features/salon_details/domain/repositories/salon_details_repository.dart';

class GetSalonRatingsUseCase {
  const GetSalonRatingsUseCase(this._repository);
  final SalonDetailsRepository _repository;

  Future<Result<ApiErrorModel, SalonRatingsPage>> call(
    int id, {
    int page = 1,
    int perPage = 15,
  }) =>
      _repository.getSalonRatings(id, page: page, perPage: perPage);
}
