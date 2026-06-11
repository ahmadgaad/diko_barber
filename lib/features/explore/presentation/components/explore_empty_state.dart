import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';

class ExploreEmptyState extends StatelessWidget {
  const ExploreEmptyState({
    super.key,
    required this.icon,
    required this.titleKey,
    required this.bodyKey,
  });

  final IconData icon;
  final String titleKey;
  final String bodyKey;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56.r, color: colors.neutral300),
          SizedBox(height: 12.h),
          Text(
            tr(titleKey),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: colors.neutral700,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            tr(bodyKey),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: colors.neutral500,
            ),
          ),
        ],
      ),
    );
  }
}
