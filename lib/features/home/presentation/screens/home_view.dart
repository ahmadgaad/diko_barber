import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:zain/core/di/service_locator.dart';
import 'package:zain/core/router/app_routes.dart';
import 'package:zain/core/services/user_session.dart';
import 'package:zain/core/shared/domain/entities/category.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/core/widgets/app_bottom_nav_bar.dart';
import 'package:zain/core/widgets/app_snack_bar.dart';
import 'package:zain/core/widgets/auth_gate.dart';
import 'package:zain/features/booking/presentation/screens/booking_view.dart';
import 'package:zain/features/explore/presentation/cubit/explore_cubit.dart';
import 'package:zain/features/explore/presentation/screens/explore_view.dart';
import 'package:zain/features/favorites/presentation/screens/favorites_view.dart';
import 'package:zain/features/home/presentation/components/banners_section.dart';
import 'package:zain/features/home/presentation/components/categories_section.dart';
import 'package:zain/features/home/presentation/components/coupons_section.dart';
import 'package:zain/features/home/presentation/components/featured_packages_section.dart';
import 'package:zain/features/home/presentation/components/featured_services_section.dart';
import 'package:zain/features/home/presentation/components/home_header.dart';
import 'package:zain/features/home/presentation/components/nearby_salons_section.dart';
import 'package:zain/features/home/presentation/cubit/banners_cubit.dart';
import 'package:zain/features/home/presentation/cubit/categories_cubit.dart';
import 'package:zain/features/home/presentation/cubit/coupons_cubit.dart';
import 'package:zain/features/home/presentation/cubit/featured_packages_cubit.dart';
import 'package:zain/features/home/presentation/cubit/featured_services_cubit.dart';
import 'package:zain/features/home/presentation/cubit/home_cubit.dart';
import 'package:zain/features/home/presentation/cubit/home_state.dart';
import 'package:zain/features/home/presentation/cubit/salons_cubit.dart';
import 'package:zain/features/home/presentation/cubit/salons_state.dart';
import 'package:zain/features/profile/presentation/screens/profile_view.dart';

class HomeScope extends InheritedWidget {
  const HomeScope({super.key, required this.onSwitchTab, required super.child});

  final Future<void> Function(HomeTab tab, {Category? category}) onSwitchTab;

  static HomeScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HomeScope>()!;

  @override
  bool updateShouldNotify(HomeScope old) => onSwitchTab != old.onSwitchTab;
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  HomeTab _currentTab = HomeTab.home;
  DateTime? _lastBackPress;

  // 0.0 = fully visible, 1.0 = fully hidden.
  // Driven directly by scroll delta (no tween) so it tracks the finger,
  // then snaps to 0/1 on scroll end.
  late final AnimationController _navController;
  double _navBarHeight = 100;

  @override
  void initState() {
    super.initState();
    _navController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    if (Platform.isAndroid) {
      GoogleMapsFlutterAndroid().warmup();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navBarHeight = (88.h + MediaQuery.paddingOf(context).bottom).clamp(
      60.0,
      200.0,
    );
  }

  void _onExploreSheetChanged(double size, double maxSize) {
    final target = size >= maxSize * 0.98 ? 1.0 : 0.0;
    _navController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  static const _protectedTabs = {
    HomeTab.bookings,
    HomeTab.favorites,
    HomeTab.profile,
  };

  Future<void> _switchTab(HomeTab tab, {Category? category}) async {
    if (_protectedTabs.contains(tab)) {
      final isAuth = await sl<UserSession>().isAuthenticated;
      if (!mounted) return;
      if (!isAuth) {
        AuthGate.show(context);
        return;
      }
    }
    _navController.animateTo(0.0, curve: Curves.easeOut);
    if (tab == HomeTab.explore) {
      context.read<ExploreCubit>().selectCategory(category);
    }
    setState(() => _currentTab = tab);
  }

  @override
  void dispose() {
    _navController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isExplore = _currentTab == HomeTab.explore;
    return HomeScope(
      onSwitchTab: _switchTab,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (_, _) {
          if (_currentTab != HomeTab.home) {
            _switchTab(HomeTab.home);
            return;
          }
          final now = DateTime.now();
          if (_lastBackPress != null &&
              now.difference(_lastBackPress!) <
                  const Duration(seconds: 2)) {
            SystemNavigator.pop();
            return;
          }
          _lastBackPress = now;
          AppSnackBar.show(
            context,
            message: tr('app.back_to_exit'),
            type: SnackBarType.info,
          );
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: colors.neutral50,
          body: Stack(
            children: [
              _buildBackground(colors),
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (_currentTab == HomeTab.explore) return false;
                  // Ignore horizontal scrolls (carousels, etc.) — only the
                  // main vertical scroll should drive the nav bar.
                  if (notification.metrics.axis != Axis.vertical) return false;

                  if (notification is ScrollUpdateNotification) {
                    final delta = notification.scrollDelta ?? 0;
                    if (notification.metrics.extentBefore <= 0) {
                      _navController.value = 0.0;
                    } else {
                      _navController.value =
                          (_navController.value + delta / _navBarHeight).clamp(
                            0.0,
                            1.0,
                          );
                    }
                  } else if (notification is ScrollEndNotification) {
                    final atTop = notification.metrics.extentBefore <= 0;
                    final snapTo = (!atTop && _navController.value >= 0.5)
                        ? 1.0
                        : 0.0;
                    _navController.animateTo(snapTo, curve: Curves.easeOut);
                  }
                  return false;
                },
                child: Positioned.fill(
                  child: isExplore
                      ? _buildTabContent()
                      : SafeArea(bottom: false, child: _buildTabContent()),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedBuilder(
                  animation: _navController,
                  builder: (context, child) => FractionalTranslation(
                    translation: Offset(0, _navController.value),
                    child: child,
                  ),
                  child: SafeArea(
                    top: false,
                    child: AppBottomNavBar(
                      currentTab: _currentTab,
                      onTabSelected: (tab) => _switchTab(tab),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
      HomeTab.explore => ExploreView(
        onSheetSizeChanged: _onExploreSheetChanged,
      ),
      HomeTab.bookings => const BookingView(),
      HomeTab.favorites => const FavoritesView(),
      HomeTab.profile => const ProfileView(),
    };
  }

  Widget _buildHomeContent() {
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
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
