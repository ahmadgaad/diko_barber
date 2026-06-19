import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zain/core/theme/app_colors.dart';

class BookingShimmerCard extends StatelessWidget {
  const BookingShimmerCard({super.key, required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: Shimmer.fromColors(
        baseColor: colors.neutral200,
        highlightColor: colors.neutral100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: colors.neutral300,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                          color: colors.neutral300,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        height: 10.h,
                        width: 80.w,
                        decoration: BoxDecoration(
                          color: colors.neutral300,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 22.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                    color: colors.neutral300,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Container(height: 1, color: colors.neutral200),
            SizedBox(height: 12.h),
            Row(
              children: [
                Container(
                  width: 15.r,
                  height: 15.r,
                  decoration: BoxDecoration(
                    color: colors.neutral300,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Container(
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: colors.neutral300,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Container(
                  height: 14.h,
                  width: 50.w,
                  decoration: BoxDecoration(
                    color: colors.neutral300,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Container(
              height: 10.h,
              width: 160.w,
              decoration: BoxDecoration(
                color: colors.neutral300,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 6.h),
            Container(
              height: 10.h,
              width: 200.w,
              decoration: BoxDecoration(
                color: colors.neutral300,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 38.h,
                    decoration: BoxDecoration(
                      color: colors.neutral300,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Container(
                    height: 38.h,
                    decoration: BoxDecoration(
                      color: colors.neutral300,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
