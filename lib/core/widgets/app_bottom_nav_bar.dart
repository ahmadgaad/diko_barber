import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ronaq_barber/core/resources/svg_resources.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';

enum HomeTab { home, explore, bookings, favorites, profile }

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  final HomeTab currentTab;
  final ValueChanged<HomeTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderRadius = BorderRadius.circular(999.r);

    final glassColor = isDark
        ? const Color(0xFF1A1A1A).withValues(alpha: 0.70)
        : Colors.white.withValues(alpha: 0.72);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : Colors.white.withValues(alpha: 0.60);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: RepaintBoundary(
        child: ClipRRect(
          borderRadius: borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              height: 64.h,
              decoration: BoxDecoration(
                color: glassColor,
                borderRadius: borderRadius,
                border: Border.all(color: borderColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.14),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: HomeTab.values.map((tab) {
                  final isActive = tab == currentTab;
                  return isActive
                      ? _ActiveTab(tab: tab, onTap: () => onTabSelected(tab))
                      : _InactiveTab(
                          tab: tab,
                          colors: colors,
                          onTap: () => onTabSelected(tab),
                        );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActiveTab extends StatelessWidget {
  const _ActiveTab({required this.tab, required this.onTap});

  final HomeTab tab;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: 36.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            gradient: buttonGradient,
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                tab.filledSvgPath,
                width: 24.w,
                height: 24.w,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                tr(tab.labelKey),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InactiveTab extends StatelessWidget {
  const _InactiveTab({
    required this.tab,
    required this.colors,
    required this.onTap,
  });

  final HomeTab tab;
  final AppColors colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: SvgPicture.asset(
              tab.svgPath,
              key: ValueKey('inactive_${tab.name}'),
              width: 24.w,
              height: 24.w,
              colorFilter: ColorFilter.mode(colors.neutral900, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}

extension on HomeTab {
  String get svgPath => switch (this) {
    HomeTab.home => SvgResources.navHome,
    HomeTab.explore => SvgResources.navExplore,
    HomeTab.bookings => SvgResources.navCalendar,
    HomeTab.favorites => SvgResources.navHeart,
    HomeTab.profile => SvgResources.navProfile,
  };

  String get filledSvgPath => switch (this) {
    HomeTab.home => SvgResources.navHomeFilled,
    HomeTab.explore => SvgResources.navExploreFilled,
    HomeTab.bookings => SvgResources.navCalendarFilled,
    HomeTab.favorites => SvgResources.navHeartFilled,
    HomeTab.profile => SvgResources.navProfileFilled,
  };

  String get labelKey => switch (this) {
    HomeTab.home => 'nav.home',
    HomeTab.explore => 'nav.explore',
    HomeTab.bookings => 'nav.bookings',
    HomeTab.favorites => 'nav.favorites',
    HomeTab.profile => 'nav.profile',
  };
}
