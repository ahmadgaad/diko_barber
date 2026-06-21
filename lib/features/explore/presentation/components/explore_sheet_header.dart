import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/features/explore/presentation/cubit/explore_state.dart';
import 'category_filter_chips.dart';

class ExploreSheetHeader extends StatelessWidget {
  const ExploreSheetHeader({super.key, required this.state});

  final ExploreState state;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: colors.neutral300,
              borderRadius: BorderRadius.circular(999.r),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
          child: Row(
            children: [
              Text(
                tr('nav.explore'),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.neutral900,
                ),
              ),
              if (state case ExploreLoaded(:final salons)) ...[
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: splashOrange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    '${salons.length}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: splashOrange,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (state case ExploreLoaded(
          :final categories,
          :final selectedCategory,
        ))
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 12.h),
            child: CategoryFilterChips(
              categories: categories,
              selectedCategory: selectedCategory,
            ),
          ),
      ],
    );
  }
}
