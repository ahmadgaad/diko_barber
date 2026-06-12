import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/di/service_locator.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/features/search/presentation/cubit/search_cubit.dart';
import 'package:ronaq_barber/features/search/presentation/screens/search_view.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocProvider(
      create: (_) => sl<SearchCubit>(),
      child: Scaffold(
        backgroundColor: colors.neutral50,
        body: const SafeArea(child: SearchView()),
      ),
    );
  }
}
