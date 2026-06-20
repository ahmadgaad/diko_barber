import 'package:zain/features/booking_schedule/domain/entities/created_appointment.dart';
import '../../domain/entities/payment_method.dart';

sealed class CheckoutState {
  const CheckoutState();
}

class CheckoutInitial extends CheckoutState {
  const CheckoutInitial();
}

class CheckoutPaymentMethodsLoading extends CheckoutState {
  const CheckoutPaymentMethodsLoading();
}

class CheckoutPaymentMethodsLoaded extends CheckoutState {
  const CheckoutPaymentMethodsLoaded({
    required this.methods,
    this.selectedMethodId,
    this.isPaying = false,
    this.payError,
  });

  final List<PaymentMethod> methods;
  final int? selectedMethodId;
  final bool isPaying;
  final String? payError;

  PaymentMethod? get selectedMethod {
    if (selectedMethodId == null) return null;
    return methods.where((m) => m.id == selectedMethodId).firstOrNull;
  }

  CheckoutPaymentMethodsLoaded copyWith({
    List<PaymentMethod>? methods,
    int? Function()? selectedMethodId,
    bool? isPaying,
    String? Function()? payError,
  }) {
    return CheckoutPaymentMethodsLoaded(
      methods: methods ?? this.methods,
      selectedMethodId: selectedMethodId != null
          ? selectedMethodId()
          : this.selectedMethodId,
      isPaying: isPaying ?? this.isPaying,
      payError: payError != null ? payError() : this.payError,
    );
  }
}

class CheckoutPaymentMethodsError extends CheckoutState {
  const CheckoutPaymentMethodsError(this.message);

  final String message;
}

class CheckoutPaymentRedirect extends CheckoutState {
  const CheckoutPaymentRedirect({
    required this.checkoutUrl,
    required this.returnUrl,
  });

  final String checkoutUrl;
  final String returnUrl;
}

class CheckoutPaymentSuccess extends CheckoutState {
  const CheckoutPaymentSuccess({required this.appointment});

  final CreatedAppointment appointment;
}
