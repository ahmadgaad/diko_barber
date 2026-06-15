import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';

class ExploreShimmer extends StatelessWidget {
  const ExploreShimmer({
    super.key,
    this.showCategoryChips = true,
    this.itemCount = 4,
  });

  /// Pass false when the real category chips are already visible in the header
  /// (i.e. during isLoadingSalons on an already-loaded state).
  final bool showCategoryChips;

  /// Number of skeleton cards to render.
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showCategoryChips) ...[
          _ChipRow(colors: colors),
          SizedBox(height: 12.h),
        ],
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 0.825,
          ),
          itemCount: itemCount,
          itemBuilder: (_, _) => _ShimmerGridCard(colors: colors),
        ),
      ],
    );
  }
}

class _ChipRow extends StatelessWidget {
  const _ChipRow({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (i) {
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
    );
  }
}

/// Skeleton that mirrors the structure of SalonGridCard.
class _ShimmerGridCard extends StatelessWidget {
  const _ShimmerGridCard({required this.colors});
  final AppColors colors;

  Widget _box(double? w, double h, double radius) => Container(
    width: w,
    height: h,
    decoration: BoxDecoration(
      color: colors.neutral200,
      borderRadius: BorderRadius.circular(radius),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover image placeholder
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
            child: _box(double.infinity, 100.h, 0),
          ),
          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + favorite icon row
                Row(
                  children: [
                    Expanded(child: _box(null, 13.h, 4.r)),
                    SizedBox(width: 8.w),
                    _box(16.r, 16.r, 4.r),
                  ],
                ),
                SizedBox(height: 4.h),
                // Star icon + rating text + dot + distance text
                Row(
                  children: [
                    _box(12.r, 12.r, 999.r),
                    SizedBox(width: 2.w),
                    _box(22.w, 11.h, 4.r),
                    SizedBox(width: 4.w),
                    _box(4.w, 4.h, 999.r),
                    SizedBox(width: 4.w),
                    _box(30.w, 11.h, 4.r),
                  ],
                ),
                SizedBox(height: 6.h),
                // Open/closed status pill
                _box(48.w, 16.h + 6.h, 999.r),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
