import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class ExploreShimmer extends StatelessWidget {
  const ExploreShimmer({super.key, this.showMapBlock = false});

  /// The explore tab shows a map preview placeholder above the grid;
  /// the full-map sheet does not.
  final bool showMapBlock;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    Widget block(double h, double r) => Container(
      height: h,
      decoration: BoxDecoration(
        color: colors.neutral200,
        borderRadius: BorderRadius.circular(r),
      ),
    );

    return Shimmer.fromColors(
      baseColor: colors.neutral200,
      highlightColor: colors.neutral100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showMapBlock) ...[block(150.h, 16.r), SizedBox(height: 12.h)],
          Row(
            children: List.generate(4, (_) {
              return Padding(
                padding: EdgeInsetsDirectional.only(end: 8.w),
                child: Container(
                  width: 70.w,
                  height: 34.h,
                  decoration: BoxDecoration(
                    color: colors.neutral200,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 12.h),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 0.78,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(4, (_) => block(0, 16.r)),
          ),
        ],
      ),
    );
  }
}
