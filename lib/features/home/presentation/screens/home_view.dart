import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zain/core/router/app_routes.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/features/home/presentation/components/banners_section.dart';
import 'package:zain/features/home/presentation/components/categories_section.dart';
import 'package:zain/features/home/presentation/components/coupons_section.dart';
import 'package:zain/features/home/presentation/components/featured_packages_section.dart';
import 'package:zain/features/home/presentation/components/featured_services_section.dart';
import 'package:zain/features/home/presentation/components/home_header.dart';
import 'package:zain/features/home/presentation/components/nearby_salons_section.dart';
import 'package:zain/features/home/presentation/cubit/home_cubit.dart';
import 'package:zain/features/home/presentation/cubit/home_state.dart';
import 'package:zain/features/home/presentation/cubit/salons_cubit.dart';
import 'package:zain/features/home/presentation/cubit/salons_state.dart';
import 'package:zain/features/home/presentation/cubit/banners_cubit.dart';
import 'package:zain/features/home/presentation/cubit/categories_cubit.dart';
import 'package:zain/features/home/presentation/cubit/coupons_cubit.dart';
import 'package:zain/features/home/presentation/cubit/featured_packages_cubit.dart';
import 'package:zain/features/home/presentation/cubit/featured_services_cubit.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SalonsCubit, SalonsState>(
      listenWhen: (_, current) =>
          current is SalonsLoaded && current.location != null,
      listener: (context, state) {
        final location = (state as SalonsLoaded).location!;
        context.read<HomeCubit>().updateLocation(location);
      },
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final loaded = state as HomeLoaded;
          return RefreshIndicator.adaptive(
            color: splashOrange,
            onRefresh: () => Future.wait([
              context.read<BannersCubit>().refresh(),
              context.read<CategoriesCubit>().refresh(),
              context.read<SalonsCubit>().refresh(),
              context.read<CouponsCubit>().refresh(),
              context.read<FeaturedPackagesCubit>().refresh(),
              context.read<FeaturedServicesCubit>().refresh(),
            ]),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: ClampingScrollPhysics(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeHeader(
                    userName: loaded.userName,
                    location: loaded.location,
                    onSearchTap: () => context.push(AppRoutes.search),
                  ),
                  const BannersSection(),
                  const CategoriesSection(),
                  const NearbySalonsSection(),
                  const CouponsSection(),
                  const FeaturedPackagesSection(),
                  const FeaturedServicesSection(),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
