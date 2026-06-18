import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/get_payment_methods_use_case.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit(this._getPaymentMethods) : super(const CheckoutInitial());

  final GetPaymentMethodsUseCase _getPaymentMethods;

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
}
