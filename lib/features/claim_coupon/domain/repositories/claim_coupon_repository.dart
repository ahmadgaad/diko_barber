import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/features/book_appointment/domain/entities/staff_member.dart';
import '../entities/available_slot.dart';
import '../entities/coupon_eligible_items.dart';

abstract interface class ClaimCouponRepository {
  Future<Result<ApiErrorModel, CouponEligibleItems>> getEligibleItems(
    int couponId,
  );

  Future<Result<ApiErrorModel, List<AvailableSlot>>> getAvailableSlots({
    required int salonId,
    required String date,
    required List<int> serviceIds,
    required List<int> packageIds,
    int? staffId,
  });

  Future<Result<ApiErrorModel, List<StaffMember>>> getAvailableBarbers({
    required int salonId,
    required String date,
    required String startTime,
    required List<int> serviceIds,
    required List<int> packageIds,
  });
}
