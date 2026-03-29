import 'package:diko_barber/core/resources/svg_resources.dart';
import 'package:diko_barber/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum HomeTab { home, services, calendar, dashboard, profile }

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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Container(
        height: 64.h,
        decoration: BoxDecoration(
          color: colors.neutral100,
          borderRadius: BorderRadius.circular(999.r),
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
        child: Container(
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
                tab.svgPath,
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
          child: SvgPicture.asset(
            tab.svgPath,
            width: 24.w,
            height: 24.w,
            colorFilter: ColorFilter.mode(colors.neutral900, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}

extension on HomeTab {
  String get svgPath => switch (this) {
    HomeTab.home => SvgResources.navHome,
    HomeTab.dashboard => SvgResources.navDashboard,
    HomeTab.calendar => SvgResources.navCalendar,
    HomeTab.services => SvgResources.navServices,
    HomeTab.profile => SvgResources.navProfile,
  };

  String get labelKey => switch (this) {
    HomeTab.home => 'nav.home',
    HomeTab.dashboard => 'nav.home',
    HomeTab.calendar => 'nav.home',
    HomeTab.services => 'nav.home',
    HomeTab.profile => 'nav.home',
  };
}
