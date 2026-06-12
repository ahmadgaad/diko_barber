import 'package:ronaq_barber/features/book_appointment/domain/entities/coupon_validation.dart';

class CouponValidationModel extends CouponValidation {
  const CouponValidationModel({
    required super.isValid,
    required super.discountAmount,
    required super.discountType,
    super.message,
  });

  factory CouponValidationModel.fromJson(Map<String, dynamic> json) {
    return CouponValidationModel(
      isValid: json['is_valid'] as bool,
      discountAmount: json['discount_amount'] as num,
      discountType: json['discount_type'] as String,
      message: json['message'] as String?,
    );
  }
}
