import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';

class BookingsErrorState extends StatelessWidget {
  const BookingsErrorState({super.key, required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 56.r,
            color: colors.neutral300,
          ),
          SizedBox(height: 12.h),
          Text(
            tr('explore.error_title'),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: colors.neutral700,
            ),
          ),
        ],
      ),
    );
  }
}
