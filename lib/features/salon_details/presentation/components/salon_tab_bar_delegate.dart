import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';

class SalonTabBarDelegate extends SliverPersistentHeaderDelegate {
  const SalonTabBarDelegate({
    required this.tabController,
    required this.colors,
  });

  final TabController tabController;
  final AppColors colors;

  static const _tabs = [
    'salon_details.tab_services',
    'salon_details.tab_packages',
    'salon_details.tab_coupons',
    'salon_details.tab_staff',
    'salon_details.tab_shifts',
    'salon_details.tab_gallery',
    'salon_details.tab_reviews',
  ];

  @override
  double get minExtent => 46;
  @override
  double get maxExtent => 46;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: colors.neutral50,
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: splashOrange, width: 2),
          insets: EdgeInsets.symmetric(horizontal: 4.w),
        ),
        indicatorColor: splashOrange,
        labelColor: splashOrange,
        unselectedLabelColor: colors.neutral500,
        labelStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
        ),
        dividerColor: colors.neutral200,
        tabs: _tabs.map((key) => Tab(text: tr(key))).toList(),
      ),
    );
  }

  @override
  bool shouldRebuild(SalonTabBarDelegate oldDelegate) =>
      oldDelegate.colors != colors;
}
