class CreatedAppointment {
  const CreatedAppointment({
    required this.id,
    required this.code,
    required this.status,
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
    required this.salon,
    required this.staff,
    required this.purchase,
    required this.services,
  });

  final int id;
  final String code;
  final AppointmentStatus status;
  final String appointmentDate;
  final String startTime;
  final String endTime;
  final AppointmentSalon salon;
  final AppointmentStaff staff;
  final AppointmentPurchase purchase;
  final List<AppointmentLineItem> services;
}

class AppointmentStatus {
  const AppointmentStatus({required this.id, required this.name});

  final int id;
  final String name;
}

class AppointmentSalon {
  const AppointmentSalon({
    required this.id,
    required this.name,
    required this.logo,
  });

  final int id;
  final String name;
  final String logo;
}

class AppointmentStaff {
  const AppointmentStaff({
    required this.id,
    required this.name,
    required this.image,
  });

  final int id;
  final String name;
  final String image;
}

class AppointmentPurchase {
  const AppointmentPurchase({
    required this.id,
    required this.code,
    required this.subTotal,
    required this.couponAmount,
    required this.tax,
    required this.taxPercentage,
    required this.homeServiceFee,
    required this.totalAmount,
    this.couponCode,
  });

  final int id;
  final String code;
  final num subTotal;
  final num couponAmount;
  final num tax;
  final num taxPercentage;
  final num homeServiceFee;
  final num totalAmount;
  final String? couponCode;
}

class AppointmentLineItem {
  const AppointmentLineItem({
    required this.id,
    required this.durationMinutes,
    required this.unitPrice,
    required this.subTotal,
    this.serviceName,
    this.categoryName,
    this.packageName,
  });

  final int id;
  final int durationMinutes;
  final String unitPrice;
  final String subTotal;
  final String? serviceName;
  final String? categoryName;
  final String? packageName;

  bool get isPackage => packageName != null;

  String get displayName => packageName ?? serviceName ?? '';
}
