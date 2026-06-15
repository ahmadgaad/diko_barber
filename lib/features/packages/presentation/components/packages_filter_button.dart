import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';

class PackagesFilterButton extends StatelessWidget {
  const PackagesFilterButton({
    super.key,
    required this.colors,
    required this.activeCount,
    required this.onTap,
  });

  final AppColors colors;
  final int activeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 44.h,
            height: 44.h,
            decoration: BoxDecoration(
              color: activeCount > 0 ? splashOrange : colors.neutral100,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: activeCount > 0 ? splashOrange : colors.neutral300,
              ),
            ),
            child: Icon(
              Icons.tune_rounded,
              size: 20.r,
              color: activeCount > 0 ? Colors.white : colors.neutral700,
            ),
          ),
        ),
        if (activeCount > 0)
          PositionedDirectional(
            top: -4.h,
            end: -4.w,
            child: Container(
              width: 16.r,
              height: 16.r,
              decoration: const BoxDecoration(
                color: Color(0xFFE53935),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '$activeCount',
                style: TextStyle(
                  fontSize: 9.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
