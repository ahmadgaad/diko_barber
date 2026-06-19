import 'package:zain/features/booking_schedule/domain/entities/created_appointment.dart';

class Booking {
  const Booking({
    required this.id,
    required this.code,
    required this.statusId,
    required this.statusName,
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
    required this.bookingType,
    required this.isRated,
    required this.salon,
    required this.staff,
    required this.purchase,
    required this.services,
    required this.actions,
    this.notes,
    this.rejectionReason,
    this.chatId,
  });

  final int id;
  final String code;
  final int statusId;
  final String statusName;
  final String appointmentDate;
  final String startTime;
  final String endTime;
  final BookingType bookingType;
  final bool isRated;
  final BookingSalon salon;
  final BookingStaff? staff;
  final BookingPurchase? purchase;
  final List<BookingService> services;
  final BookingActions actions;
  final String? notes;
  final String? rejectionReason;
  final int? chatId;

  String get servicesDisplay => services
      .map((s) => s.serviceName ?? s.packageName ?? s.categoryName)
      .join('، ');

  double get totalAmount => purchase?.totalAmount ?? 0;

  CreatedAppointment toCreatedAppointment() => CreatedAppointment(
        id: id,
        code: code,
        status: AppointmentStatus(id: statusId, name: statusName),
        appointmentDate: appointmentDate,
        startTime: startTime,
        endTime: endTime,
        salon: AppointmentSalon(
          id: salon.id,
          name: salon.name,
          logo: salon.logo,
        ),
        staff: AppointmentStaff(
          id: staff?.id ?? 0,
          name: staff?.name ?? '',
          image: staff?.image ?? '',
        ),
        purchase: AppointmentPurchase(
          id: purchase?.id ?? 0,
          code: purchase?.code ?? '',
          subTotal: purchase?.subTotal ?? 0,
          couponAmount: purchase?.couponAmount ?? 0,
          tax: purchase?.tax ?? 0,
          taxPercentage: purchase?.taxPercentage ?? 0,
          homeServiceFee: purchase?.homeServiceFee ?? 0,
          commissionAmount: purchase?.commissionAmount ?? 0,
          platformCommissionPercentage: purchase?.platformCommissionPercentage ?? 0,
          totalAmount: purchase?.totalAmount ?? 0,
          couponCode: purchase?.couponCode,
        ),
        services: services
            .map(
              (s) => AppointmentLineItem(
                id: s.id,
                durationMinutes: s.durationMinutes,
                unitPrice: s.unitPrice.toStringAsFixed(2),
                subTotal: s.subTotal.toStringAsFixed(2),
                serviceName: s.serviceName,
                categoryName: s.categoryName,
                packageName: s.packageName,
              ),
            )
            .toList(),
      );
}

class BookingType {
  const BookingType({required this.id, required this.name});

  final int id;
  final String name;
}

class BookingSalon {
  const BookingSalon({
    required this.id,
    required this.name,
    required this.logo,
    this.location,
    this.averageRating,
    this.phone,
  });

  final int id;
  final String name;
  final String logo;
  final String? location;
  final double? averageRating;
  final String? phone;
}

class BookingStaff {
  const BookingStaff({
    required this.id,
    required this.name,
    this.image,
    this.averageRating,
  });

  final int id;
  final String name;
  final String? image;
  final double? averageRating;
}

class BookingPurchase {
  const BookingPurchase({
    required this.id,
    required this.code,
    required this.subTotal,
    required this.couponAmount,
    required this.tax,
    required this.taxPercentage,
    required this.homeServiceFee,
    required this.commissionAmount,
    required this.platformCommissionPercentage,
    required this.totalAmount,
    required this.paymentStatusId,
    required this.paymentStatusName,
    this.couponCode,
  });

  final int id;
  final String code;
  final double subTotal;
  final double couponAmount;
  final double tax;
  final double taxPercentage;
  final double homeServiceFee;
  final double commissionAmount;
  final double platformCommissionPercentage;
  final double totalAmount;
  final int paymentStatusId;
  final String paymentStatusName;
  final String? couponCode;
}

class BookingService {
  const BookingService({
    required this.id,
    required this.serviceName,
    required this.categoryName,
    required this.durationMinutes,
    required this.unitPrice,
    required this.subTotal,
    this.packageName,
  });

  final int id;
  final String? serviceName;
  final String categoryName;
  final int durationMinutes;
  final double unitPrice;
  final double subTotal;
  final String? packageName;
}

class BookingActions {
  const BookingActions({
    required this.canPay,
    required this.canCancel,
    required this.canReschedule,
    required this.canComplete,
    required this.canRate,
    required this.canChat,
  });

  final bool canPay;
  final bool canCancel;
  final bool canReschedule;
  final bool canComplete;
  final bool canRate;
  final bool canChat;

  bool get hasAny =>
      canPay || canCancel || canReschedule || canComplete || canRate;
}
