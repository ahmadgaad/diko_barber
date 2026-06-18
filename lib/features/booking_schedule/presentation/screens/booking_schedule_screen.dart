import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/di/service_locator.dart';
import 'package:zain/features/claim_coupon/domain/use_cases/get_available_barbers_use_case.dart';
import 'package:zain/features/claim_coupon/domain/use_cases/get_available_slots_use_case.dart';
import '../../domain/use_cases/create_appointment_use_case.dart';
import '../booking_schedule_args.dart';
import '../cubit/booking_schedule_cubit.dart';
import 'booking_schedule_view.dart';

class BookingScheduleScreen extends StatelessWidget {
  const BookingScheduleScreen({super.key, required this.args});

  final BookingScheduleArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingScheduleCubit(
        getAvailableSlots: sl<GetAvailableSlotsUseCase>(),
        getAvailableBarbers: sl<GetAvailableBarbersUseCase>(),
        createAppointment: sl<CreateAppointmentUseCase>(),
        salonId: args.salonId,
        salonName: args.salonName,
        serviceIds: args.serviceIds.toList(),
        packageIds: args.packageIds.toList(),
        couponCode: args.couponCode,
      ),
      child: const BookingScheduleView(),
    );
  }
}
