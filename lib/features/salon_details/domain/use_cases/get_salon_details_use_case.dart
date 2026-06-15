import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/salon_details/domain/entities/salon_details.dart';
import 'package:zain/features/salon_details/domain/repositories/salon_details_repository.dart';

class GetSalonDetailsUseCase {
  const GetSalonDetailsUseCase(this._repository);
  final SalonDetailsRepository _repository;

  Future<Result<ApiErrorModel, SalonDetails>> call(
    int id, {
    double? lat,
    double? long,
  }) =>
      _repository.getSalonDetails(id, lat: lat, long: long);
}
