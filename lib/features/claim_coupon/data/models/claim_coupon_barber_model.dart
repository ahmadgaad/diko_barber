import 'package:zain/features/book_appointment/domain/entities/staff_member.dart';

class ClaimCouponBarberModel extends StaffMember {
  const ClaimCouponBarberModel({
    required super.id,
    required super.name,
    required super.avatar,
    required super.specialization,
  });

  factory ClaimCouponBarberModel.fromJson(Map<String, dynamic> json) {
    return ClaimCouponBarberModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      avatar: json['image'] as String? ?? '',
      specialization: (json['city'] as Map<String, dynamic>?)?['name'] as String? ?? '',
    );
  }
}
