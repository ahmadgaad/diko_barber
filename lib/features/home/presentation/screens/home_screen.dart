import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/di/service_locator.dart';
import 'package:ronaq_barber/features/booking/presentation/cubit/bookings_cubit.dart';
import 'package:ronaq_barber/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:ronaq_barber/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:ronaq_barber/features/explore/presentation/cubit/explore_cubit.dart';
import 'package:ronaq_barber/features/home/presentation/cubit/banners_cubit.dart';
import 'package:ronaq_barber/features/home/presentation/cubit/categories_cubit.dart';
import 'package:ronaq_barber/features/home/presentation/cubit/coupons_cubit.dart';
import 'package:ronaq_barber/features/home/presentation/cubit/featured_packages_cubit.dart';
import 'package:ronaq_barber/features/home/presentation/cubit/featured_services_cubit.dart';
import 'package:ronaq_barber/features/home/presentation/cubit/home_cubit.dart';
import 'package:ronaq_barber/features/home/presentation/cubit/salons_cubit.dart';
import 'package:ronaq_barber/features/home/presentation/screens/home_view.dart';

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
        BlocProvider(create: (_) => sl<ExploreCubit>()),
        BlocProvider(create: (_) => sl<BookingsCubit>()),
        BlocProvider(create: (_) => sl<FavoritesCubit>()),
        BlocProvider(create: (_) => sl<ProfileCubit>()),
      ],
      child: const HomeView(),
    );
  }
}
