import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';

class SalonDetailsErrorView extends StatelessWidget {
  const SalonDetailsErrorView({super.key, required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.neutral50,
      appBar: AppBar(
        backgroundColor: colors.neutral50,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colors.neutral900,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
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
            SizedBox(height: 4.h),
            Text(
              tr('explore.error_body'),
              style: TextStyle(fontSize: 13.sp, color: colors.neutral500),
            ),
          ],
        ),
      ),
    );
  }
}
