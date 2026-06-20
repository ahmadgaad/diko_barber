import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/payment_result.dart';
import '../../domain/use_cases/get_payment_methods_use_case.dart';
import '../../domain/use_cases/pay_appointment_use_case.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit(this._getPaymentMethods, this._payAppointment)
      : super(const CheckoutInitial());

  final GetPaymentMethodsUseCase _getPaymentMethods;
  final PayAppointmentUseCase _payAppointment;

  Future<void> loadPaymentMethods() async {
    emit(const CheckoutPaymentMethodsLoading());
    final result = await _getPaymentMethods();
    if (isClosed) return;
    result.when(
      success: (methods) =>
          emit(CheckoutPaymentMethodsLoaded(methods: methods)),
      failure: (error) =>
          emit(CheckoutPaymentMethodsError(error.message)),
    );
  }

  void selectMethod(int methodId) {
    final current = state;
    if (current is! CheckoutPaymentMethodsLoaded) return;
    emit(current.copyWith(selectedMethodId: () => methodId));
  }

  Future<void> payAppointment(int appointmentId) async {
    final current = state;
    if (current is! CheckoutPaymentMethodsLoaded) return;
    if (current.selectedMethodId == null) return;

    emit(current.copyWith(isPaying: true, payError: () => null));

    final result = await _payAppointment(
      appointmentId: appointmentId,
      paymentMethodId: current.selectedMethodId!,
    );

    if (isClosed) return;

    result.when(
      success: (paymentResult) {
        switch (paymentResult) {
          case PaymentRedirect(:final checkoutUrl, :final returnUrl):
            emit(CheckoutPaymentRedirect(
              checkoutUrl: checkoutUrl,
              returnUrl: returnUrl,
            ));
          case PaymentSuccess(:final appointment):
            emit(CheckoutPaymentSuccess(appointment: appointment));
        }
      },
      failure: (error) {
        final latest = state;
        if (latest is CheckoutPaymentMethodsLoaded) {
          emit(latest.copyWith(
            isPaying: false,
            payError: () => error.message,
          ));
        }
      },
    );
  }
}
