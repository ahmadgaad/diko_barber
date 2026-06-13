import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/core/shared/domain/entities/salon_details.dart';
import 'package:ronaq_barber/core/shared/domain/repositories/shared_repository.dart';

class GetSalonDetailsUseCase {
  const GetSalonDetailsUseCase(this._repository);
  final SharedRepository _repository;

  Future<Result<ApiErrorModel, SalonDetails>> call(
    int id, {
    double? lat,
    double? long,
  }) =>
      _repository.getSalonDetails(id, lat: lat, long: long);
}
