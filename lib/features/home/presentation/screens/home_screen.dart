import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/di/service_locator.dart';
import 'package:zain/features/home/presentation/cubit/banners_cubit.dart';
import 'package:zain/features/home/presentation/cubit/categories_cubit.dart';
import 'package:zain/features/home/presentation/cubit/coupons_cubit.dart';
import 'package:zain/features/home/presentation/cubit/featured_packages_cubit.dart';
import 'package:zain/features/home/presentation/cubit/featured_services_cubit.dart';
import 'package:zain/features/home/presentation/cubit/home_cubit.dart';
import 'package:zain/features/home/presentation/cubit/salons_cubit.dart';
import 'package:zain/features/home/presentation/screens/home_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<HomeCubit>()),
        BlocProvider(create: (_) => sl<BannersCubit>()),
        BlocProvider(create: (_) => sl<CategoriesCubit>()),
        BlocProvider(create: (_) => sl<SalonsCubit>()),
        BlocProvider(create: (_) => sl<CouponsCubit>()),
        BlocProvider(create: (_) => sl<FeaturedPackagesCubit>()),
        BlocProvider(create: (_) => sl<FeaturedServicesCubit>()),
      ],
      child: const HomeView(),
    );
  }
}
