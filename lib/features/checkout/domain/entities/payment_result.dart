import 'package:zain/features/booking_schedule/domain/entities/created_appointment.dart';

sealed class PaymentResult {
  const PaymentResult();
}

class PaymentRedirect extends PaymentResult {
  const PaymentRedirect({
    required this.checkoutUrl,
    required this.returnUrl,
  });

  final String checkoutUrl;
  final String returnUrl;
}

class PaymentSuccess extends PaymentResult {
  const PaymentSuccess({required this.appointment});

  final CreatedAppointment appointment;
}
