import 'package:zain/features/book_appointment/domain/entities/staff_member.dart';

class StaffMemberModel extends StaffMember {
  const StaffMemberModel({
    required super.id,
    required super.name,
    required super.avatar,
    required super.specialization,
  });

  factory StaffMemberModel.fromJson(Map<String, dynamic> json) {
    return StaffMemberModel(
      id: json['id'] as int,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      specialization: json['specialization'] as String,
    );
  }
}
