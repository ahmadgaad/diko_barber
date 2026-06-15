import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';

class EmptyTab extends StatelessWidget {
  const EmptyTab({
    super.key,
    required this.icon,
    required this.message,
    required this.colors,
  });

  final IconData icon;
  final String message;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48.r, color: colors.neutral300),
          SizedBox(height: 10.h),
          Text(
            message,
            style: TextStyle(fontSize: 13.sp, color: colors.neutral500),
          ),
        ],
      ),
    );
  }
}
