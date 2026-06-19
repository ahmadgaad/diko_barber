import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:zain/core/di/service_locator.dart';
import 'package:zain/core/services/user_session.dart';
import 'package:zain/core/shared/domain/entities/category.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/core/widgets/app_bottom_nav_bar.dart';
import 'package:zain/core/widgets/app_snack_bar.dart';
import 'package:zain/core/widgets/auth_gate.dart';
import 'package:zain/features/booking/presentation/cubit/bookings_cubit.dart';
import 'package:zain/features/explore/presentation/cubit/explore_cubit.dart';

class HomeScope extends InheritedWidget {
  const HomeScope({super.key, required this.onSwitchTab, required super.child});

  final Future<void> Function(HomeTab tab, {Category? category}) onSwitchTab;

  static HomeScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HomeScope>()!;

  @override
  bool updateShouldNotify(HomeScope old) => onSwitchTab != old.onSwitchTab;
}

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell>
    with SingleTickerProviderStateMixin {
  DateTime? _lastBackPress;

  late final AnimationController _navController;
  double _navBarHeight = 100;

  static const _protectedTabs = {
    HomeTab.bookings,
    HomeTab.favorites,
    HomeTab.profile,
  };

  HomeTab get _currentTab =>
      HomeTab.values[widget.navigationShell.currentIndex];

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
    if (tab == HomeTab.explore && category != null) {
      context.read<ExploreCubit>().selectCategory(category);
    }
    widget.navigationShell.goBranch(tab.index);
  }

  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.navigationShell.currentIndex != oldWidget.navigationShell.currentIndex &&
        _currentTab == HomeTab.bookings) {
      context.read<BookingsCubit>().refresh();
    }
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
              now.difference(_lastBackPress!) < const Duration(seconds: 2)) {
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
                  if (isExplore) return false;
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
                    final snapTo =
                        (!atTop && _navController.value >= 0.5) ? 1.0 : 0.0;
                    _navController.animateTo(snapTo, curve: Curves.easeOut);
                  }
                  return false;
                },
                child: Positioned.fill(
                  child: isExplore
                      ? _ExploreShellWrapper(
                          navigationShell: widget.navigationShell,
                          onSheetSizeChanged: _onExploreSheetChanged,
                        )
                      : SafeArea(
                          bottom: false,
                          child: widget.navigationShell,
                        ),
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
}

// Passes the explore sheet size callback into the ExploreView via InheritedWidget
// without needing to import ExploreView here.
class ExploreShellCallback extends InheritedWidget {
  const ExploreShellCallback({
    super.key,
    required this.onSheetSizeChanged,
    required super.child,
  });

  final void Function(double size, double maxSize) onSheetSizeChanged;

  static ExploreShellCallback? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ExploreShellCallback>();

  @override
  bool updateShouldNotify(ExploreShellCallback old) =>
      onSheetSizeChanged != old.onSheetSizeChanged;
}

class _ExploreShellWrapper extends StatelessWidget {
  const _ExploreShellWrapper({
    required this.navigationShell,
    required this.onSheetSizeChanged,
  });

  final StatefulNavigationShell navigationShell;
  final void Function(double size, double maxSize) onSheetSizeChanged;

  @override
  Widget build(BuildContext context) {
    return ExploreShellCallback(
      onSheetSizeChanged: onSheetSizeChanged,
      child: navigationShell,
    );
  }
}
