import '../../domain/entities/created_appointment.dart';

class CreatedAppointmentModel extends CreatedAppointment {
  const CreatedAppointmentModel({
    required super.id,
    required super.code,
    required super.status,
    required super.appointmentDate,
    required super.startTime,
    required super.endTime,
    required super.salon,
    required super.staff,
    required super.purchase,
    required super.services,
  });

  factory CreatedAppointmentModel.fromJson(Map<String, dynamic> json) {
    return CreatedAppointmentModel(
      id: json['id'] as int,
      code: json['code'] as String,
      status: AppointmentStatus(
        id: (json['status'] as Map<String, dynamic>)['id'] as int,
        name: (json['status'] as Map<String, dynamic>)['name'] as String,
      ),
      appointmentDate: json['appointment_date'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      salon: _parseSalon(json['salon'] as Map<String, dynamic>),
      staff: _parseStaff(json['staff'] as Map<String, dynamic>),
      purchase: _parsePurchase(json['purchase'] as Map<String, dynamic>),
      services: (json['services'] as List)
          .whereType<Map<String, dynamic>>()
          .map(_parseLineItem)
          .toList(),
    );
  }

  static AppointmentSalon _parseSalon(Map<String, dynamic> json) {
    return AppointmentSalon(
      id: json['id'] as int,
      name: json['name'] as String,
      logo: (json['logo'] ?? json['image'] ?? '') as String,
    );
  }

  static AppointmentStaff _parseStaff(Map<String, dynamic> json) {
    return AppointmentStaff(
      id: json['id'] as int,
      name: json['name'] as String,
      image: (json['image'] ?? '') as String,
    );
  }

  static AppointmentPurchase _parsePurchase(Map<String, dynamic> json) {
    return AppointmentPurchase(
      id: json['id'] as int,
      code: json['code'] as String,
      subTotal: json['sub_total'] as num,
      couponAmount: json['coupon_amount'] as num? ?? 0,
      tax: json['tax'] as num? ?? 0,
      taxPercentage: json['tax_percentage'] as num? ?? 0,
      homeServiceFee: json['home_service_fee'] as num? ?? 0,
      totalAmount: json['total_amount'] as num,
      couponCode: json['coupon_code'] as String?,
    );
  }

  static AppointmentLineItem _parseLineItem(Map<String, dynamic> json) {
    return AppointmentLineItem(
      id: json['id'] as int,
      serviceName: json['service_name'] as String?,
      categoryName: json['category_name'] as String?,
      packageName: json['package_name'] as String?,
      durationMinutes: json['duration_minutes'] as int,
      unitPrice: '${json['unit_price']}',
      subTotal: '${json['sub_total']}',
    );
  }
}
