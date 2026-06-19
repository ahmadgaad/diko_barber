import 'package:zain/core/shared/domain/entities/booking.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.code,
    required super.statusId,
    required super.statusName,
    required super.appointmentDate,
    required super.startTime,
    required super.endTime,
    required super.bookingType,
    required super.isRated,
    required super.salon,
    required super.staff,
    required super.purchase,
    required super.services,
    required super.actions,
    super.notes,
    super.rejectionReason,
    super.chatId,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final status = json['status'] as Map<String, dynamic>;
    final bookingTypeJson = json['booking_type'] as Map<String, dynamic>;
    final salonJson = json['salon'] as Map<String, dynamic>;
    final staffJson = json['staff'] as Map<String, dynamic>?;
    final purchaseJson = json['purchase'] as Map<String, dynamic>?;
    final actionsJson = json['actions'] as Map<String, dynamic>;
    final servicesJson = json['services'] as List? ?? [];

    return BookingModel(
      id: json['id'] as int,
      code: json['code'] as String,
      statusId: status['id'] as int,
      statusName: status['name'] as String,
      appointmentDate: json['appointment_date'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      bookingType: BookingType(
        id: bookingTypeJson['id'] as int,
        name: bookingTypeJson['name'] as String,
      ),
      isRated: json['is_rated'] as bool? ?? false,
      salon: _parseSalon(salonJson),
      staff: staffJson != null ? _parseStaff(staffJson) : null,
      purchase: purchaseJson != null ? _parsePurchase(purchaseJson) : null,
      services: servicesJson
          .whereType<Map<String, dynamic>>()
          .map(_parseService)
          .toList(),
      actions: BookingActions(
        canPay: actionsJson['can_pay'] as bool? ?? false,
        canCancel: actionsJson['can_cancel'] as bool? ?? false,
        canReschedule: actionsJson['can_reschedule'] as bool? ?? false,
        canComplete: actionsJson['can_complete'] as bool? ?? false,
        canRate: actionsJson['can_rate'] as bool? ?? false,
        canChat: actionsJson['can_chat'] as bool? ?? false,
      ),
      notes: json['notes'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
      chatId: json['chat_id'] as int?,
    );
  }

  static BookingSalon _parseSalon(Map<String, dynamic> json) {
    return BookingSalon(
      id: json['id'] as int,
      name: json['name'] as String,
      logo: json['logo'] as String? ?? '',
      location: json['location'] as String?,
      averageRating: (json['average_rating'] as num?)?.toDouble(),
      phone: json['phone'] as String?,
    );
  }

  static BookingStaff _parseStaff(Map<String, dynamic> json) {
    return BookingStaff(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String?,
      averageRating: (json['average_rating'] as num?)?.toDouble(),
    );
  }

  static BookingPurchase _parsePurchase(Map<String, dynamic> json) {
    final purchaseStatus = json['status'] as Map<String, dynamic>?;
    return BookingPurchase(
      id: json['id'] as int,
      code: json['code'] as String,
      subTotal: (json['sub_total'] as num).toDouble(),
      couponAmount: (json['coupon_amount'] as num?)?.toDouble() ?? 0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0,
      taxPercentage: (json['tax_percentage'] as num?)?.toDouble() ?? 0,
      homeServiceFee: (json['home_service_fee'] as num?)?.toDouble() ?? 0,
      commissionAmount: (json['commission_amount'] as num?)?.toDouble() ?? 0,
      platformCommissionPercentage: (json['platform_commission_percentage'] as num?)?.toDouble() ?? 0,
      totalAmount: (json['total_amount'] as num).toDouble(),
      paymentStatusId: purchaseStatus?['id'] as int? ?? 0,
      paymentStatusName: purchaseStatus?['name'] as String? ?? '',
      couponCode: json['coupon_code'] as String?,
    );
  }

  static BookingService _parseService(Map<String, dynamic> json) {
    return BookingService(
      id: json['id'] as int,
      serviceName: json['service_name'] as String?,
      categoryName: json['category_name'] as String? ?? '',
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      unitPrice: double.tryParse(json['unit_price']?.toString() ?? '') ?? 0,
      subTotal: double.tryParse(json['sub_total']?.toString() ?? '') ?? 0,
      packageName: json['package_name'] as String?,
    );
  }
}
