import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/di/service_locator.dart';
import 'package:ronaq_barber/features/book_appointment/presentation/book_appointment_args.dart';
import 'package:ronaq_barber/features/book_appointment/presentation/cubit/book_appointment_cubit.dart';
import 'package:ronaq_barber/features/book_appointment/presentation/screens/book_appointment_view.dart';

class BookAppointmentScreen extends StatelessWidget {
  const BookAppointmentScreen({super.key, required this.args});

  final BookAppointmentArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BookAppointmentCubit>()
        ..load(args.salonId, args.salonName, couponCode: args.couponCode),
      child: const BookAppointmentView(),
    );
  }
}
