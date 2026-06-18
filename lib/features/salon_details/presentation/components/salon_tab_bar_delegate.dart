import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';

class SalonTabBarDelegate extends SliverPersistentHeaderDelegate {
  const SalonTabBarDelegate({
    required this.tabController,
    required this.colors,
    this.selectedServiceCount = 0,
    this.selectedPackageCount = 0,
  });

  final TabController tabController;
  final AppColors colors;
  final int selectedServiceCount;
  final int selectedPackageCount;

  static const _otherTabs = [
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
        tabs: [
          _BadgeTab(
            label: tr('salon_details.tab_services'),
            count: selectedServiceCount,
          ),
          _BadgeTab(
            label: tr('salon_details.tab_packages'),
            count: selectedPackageCount,
          ),
          ..._otherTabs.map((key) => Tab(text: tr(key))),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(SalonTabBarDelegate oldDelegate) =>
      oldDelegate.colors != colors ||
      oldDelegate.selectedServiceCount != selectedServiceCount ||
      oldDelegate.selectedPackageCount != selectedPackageCount;
}

class _BadgeTab extends StatelessWidget {
  const _BadgeTab({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (count > 0) ...[
            SizedBox(width: 6.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: splashOrange,
                borderRadius: BorderRadius.circular(99.r),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
