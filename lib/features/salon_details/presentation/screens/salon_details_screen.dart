import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/di/service_locator.dart';
import 'package:ronaq_barber/features/salon_details/presentation/cubit/salon_details_cubit.dart';
import 'package:ronaq_barber/features/salon_details/presentation/screens/salon_details_view.dart';

class SalonDetailsScreen extends StatelessWidget {
  const SalonDetailsScreen({super.key, required this.salonId});

  final int salonId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SalonDetailsCubit>()..load(salonId),
      child: const SalonDetailsView(),
    );
  }
}
