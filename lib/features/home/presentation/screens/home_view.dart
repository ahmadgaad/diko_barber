import 'package:diko_barber/core/theme/app_colors.dart';
import 'package:diko_barber/core/widgets/app_bottom_nav_bar.dart';
import 'package:diko_barber/features/booking/presentation/screens/booking_view.dart';
import 'package:diko_barber/features/home/presentation/components/home_header.dart';
import 'package:diko_barber/features/home/presentation/components/packages_section.dart';
import 'package:diko_barber/features/home/presentation/components/promo_banner.dart';
import 'package:diko_barber/features/home/presentation/components/services_section.dart';
import 'package:diko_barber/features/home/presentation/cubit/home_cubit.dart';
import 'package:diko_barber/features/home/presentation/cubit/home_state.dart';
import 'package:diko_barber/features/packages/presentation/screens/packages_view.dart';
import 'package:diko_barber/features/profile/presentation/screens/profile_view.dart';
import 'package:diko_barber/features/services/presentation/screens/services_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeTab _currentTab = HomeTab.home;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.neutral50,
      body: Stack(
        children: [
          _buildBackground(colors),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    layoutBuilder: (currentChild, previousChildren) {
                      return Stack(
                        alignment: AlignmentDirectional.topStart,
                        children: [...previousChildren, ?currentChild],
                      );
                    },
                    child: SizedBox.expand(
                      key: ValueKey(_currentTab),
                      child: _buildTabContent(),
                    ),
                  ),
                ),
                AppBottomNavBar(
                  currentTab: _currentTab,
                  onTabSelected: (tab) => setState(() => _currentTab = tab),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(AppColors colors) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 406.h,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              splashOrange.withValues(alpha: 0.66),
              colors.neutral50.withValues(alpha: 0.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return switch (_currentTab) {
      HomeTab.home => _buildHomeContent(),
      HomeTab.services => const ServicesView(),
      HomeTab.booking => const BookingView(),
      HomeTab.packages => const PackagesView(),
      HomeTab.profile => const ProfileView(),
    };
  }

  Widget _buildHomeContent() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final loaded = state as HomeLoaded;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(userName: loaded.userName),
              const PromoBanner(),
              const ServicesSection(),
              const PackagesSection(),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }
}
