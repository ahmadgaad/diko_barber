import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/book_appointment/domain/entities/staff_member.dart';
import '../repositories/claim_coupon_repository.dart';

class GetAvailableBarbersUseCase {
  const GetAvailableBarbersUseCase(this._repository);

  final ClaimCouponRepository _repository;

  Future<Result<ApiErrorModel, List<StaffMember>>> call({
    required int salonId,
    required String date,
    required String startTime,
    required List<int> serviceIds,
    required List<int> packageIds,
  }) =>
      _repository.getAvailableBarbers(
        salonId: salonId,
        date: date,
        startTime: startTime,
        serviceIds: serviceIds,
        packageIds: packageIds,
      );
}
