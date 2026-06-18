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
  });

  final List<PaymentMethod> methods;
  final int? selectedMethodId;

  PaymentMethod? get selectedMethod {
    if (selectedMethodId == null) return null;
    return methods.where((m) => m.id == selectedMethodId).firstOrNull;
  }

  CheckoutPaymentMethodsLoaded copyWith({
    List<PaymentMethod>? methods,
    int? Function()? selectedMethodId,
  }) {
    return CheckoutPaymentMethodsLoaded(
      methods: methods ?? this.methods,
      selectedMethodId: selectedMethodId != null
          ? selectedMethodId()
          : this.selectedMethodId,
    );
  }
}

class CheckoutPaymentMethodsError extends CheckoutState {
  const CheckoutPaymentMethodsError(this.message);

  final String message;
}
