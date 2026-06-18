import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/di/service_locator.dart';
import 'package:zain/features/booking_schedule/domain/entities/created_appointment.dart';
import '../cubit/checkout_cubit.dart';
import 'checkout_view.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key, required this.appointment});

  final CreatedAppointment appointment;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CheckoutCubit>(),
      child: CheckoutView(appointment: appointment),
    );
  }
}
