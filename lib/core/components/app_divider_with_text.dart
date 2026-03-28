import 'package:diko_barber/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDividerWithText extends StatelessWidget {
  const AppDividerWithText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Row(
      children: [
        Expanded(child: Divider(color: colors.neutral300, height: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: colors.neutral600,
            ),
          ),
        ),
        Expanded(child: Divider(color: colors.neutral300, height: 1)),
      ],
    );
  }
}
