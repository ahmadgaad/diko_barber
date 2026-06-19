import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';

class BookingsEmptyState extends StatelessWidget {
  const BookingsEmptyState({super.key, required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 64.r,
            color: colors.neutral300,
          ),
          SizedBox(height: 16.h),
          Text(
            tr('bookings.empty_title'),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: colors.neutral700,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            tr('bookings.empty_body'),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.sp, color: colors.neutral500),
          ),
        ],
      ),
    );
  }
}
