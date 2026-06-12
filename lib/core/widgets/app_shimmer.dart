import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

/// Wraps any skeleton widget with the app shimmer animation.
///
/// Usage:
/// ```dart
/// AppShimmer(child: SkeletonCard())
/// ```
class AppShimmer extends StatelessWidget {
  const AppShimmer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Shimmer.fromColors(
      baseColor: colors.neutral200,
      highlightColor: colors.neutral100,
      child: child,
    );
  }
}

/// A plain rounded rectangle skeleton block — combine these to build skeletons.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.isCircle = false,
  });

  final double width;
  final double height;
  final double? borderRadius;
  final bool isCircle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle
            ? null
            : BorderRadius.circular(borderRadius ?? 8.r),
      ),
    );
  }
}

/// Ready-made skeleton for a generic list tile (avatar + two text lines).
class ShimmerListTile extends StatelessWidget {
  const ShimmerListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          ShimmerBox(width: 48.w, height: 48.w, isCircle: true),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: double.infinity, height: 14.h),
                SizedBox(height: 8.h),
                ShimmerBox(width: 120.w, height: 12.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Ready-made skeleton for a card (image + two text lines below).
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(
            width: double.infinity,
            height: height ?? 140.h,
            borderRadius: 12.r,
          ),
          SizedBox(height: 10.h),
          ShimmerBox(width: double.infinity, height: 14.h),
          SizedBox(height: 6.h),
          ShimmerBox(width: 100.w, height: 12.h),
        ],
      ),
    );
  }
}

/// Repeats [child] n times inside a Column — shorthand for list skeletons.
class ShimmerList extends StatelessWidget {
  const ShimmerList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  final int itemCount;
  final Widget Function(int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        children: List.generate(itemCount, itemBuilder),
      ),
    );
  }
}
