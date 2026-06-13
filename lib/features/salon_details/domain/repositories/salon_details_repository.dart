import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/features/salon_details/domain/entities/salon_details.dart';

abstract class SalonDetailsRepository {
  Future<Result<ApiErrorModel, SalonDetails>> getSalonDetails(
    int id, {
    double? lat,
    double? long,
  });
}
