import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import '../entities/available_slot.dart';
import '../repositories/claim_coupon_repository.dart';

class GetAvailableSlotsUseCase {
  const GetAvailableSlotsUseCase(this._repository);

  final ClaimCouponRepository _repository;

  Future<Result<ApiErrorModel, List<AvailableSlot>>> call({
    required int salonId,
    required String date,
    required List<int> serviceIds,
    required List<int> packageIds,
    int? staffId,
  }) =>
      _repository.getAvailableSlots(
        salonId: salonId,
        date: date,
        serviceIds: serviceIds,
        packageIds: packageIds,
        staffId: staffId,
      );
}
