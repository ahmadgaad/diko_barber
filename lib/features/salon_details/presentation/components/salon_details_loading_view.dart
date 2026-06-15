import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class SalonDetailsLoadingView extends StatelessWidget {
  const SalonDetailsLoadingView({super.key, required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    Widget box(double w, double h, {double radius = 6}) => Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: colors.neutral200,
        borderRadius: BorderRadius.circular(radius.r),
      ),
    );

    return Scaffold(
      backgroundColor: colors.neutral50,
      body: Shimmer.fromColors(
        baseColor: colors.neutral200,
        highlightColor: colors.neutral100,
        child: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            // Cover image
            SliverToBoxAdapter(
              child: Container(height: 240.h, color: colors.neutral200),
            ),
            // Salon info section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + rating
                    Row(
                      children: [
                        Expanded(child: box(200.w, 22.h)),
                        SizedBox(width: 8.w),
                        box(52.w, 28.h, radius: 10),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    // Meta row
                    box(220.w, 14.h),
                    SizedBox(height: 10.h),
                    // Address
                    box(180.w, 14.h),
                    SizedBox(height: 12.h),
                    // Categories chips
                    Row(
                      children: [
                        box(60.w, 24.h, radius: 999),
                        SizedBox(width: 6.w),
                        box(80.w, 24.h, radius: 999),
                        SizedBox(width: 6.w),
                        box(70.w, 24.h, radius: 999),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    // Description
                    box(double.infinity, 12.h),
                    SizedBox(height: 6.h),
                    box(double.infinity, 12.h),
                    SizedBox(height: 6.h),
                    box(140.w, 12.h),
                  ],
                ),
              ),
            ),
            // Tab bar strip
            SliverToBoxAdapter(
              child: Container(
                height: 46.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    box(60.w, 16.h),
                    SizedBox(width: 20.w),
                    box(60.w, 16.h),
                    SizedBox(width: 20.w),
                    box(60.w, 16.h),
                  ],
                ),
              ),
            ),
            // Service tiles
            SliverPadding(
              padding: EdgeInsets.all(16.w),
              sliver: SliverList.separated(
                itemCount: 4,
                separatorBuilder: (_, _) => SizedBox(height: 10.h),
                itemBuilder: (_, _) => _ServiceTileSkeleton(colors: colors),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceTileSkeleton extends StatelessWidget {
  const _ServiceTileSkeleton({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    Widget box(double w, double h, {double radius = 6}) => Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: colors.neutral200,
        borderRadius: BorderRadius.circular(radius.r),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(15.r),
                bottomStart: Radius.circular(15.r),
              ),
              child: Container(
                width: 100.w,
                height: 110.h,
                color: colors.neutral200,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    box(140.w, 15.h),
                    box(double.infinity, 12.h),
                    Row(
                      children: [
                        box(60.w, 22.h, radius: 999),
                        SizedBox(width: 6.w),
                        box(44.w, 22.h, radius: 999),
                        const Spacer(),
                        box(46.w, 15.h),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
