import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';

class PaymentCountdownBanner extends StatelessWidget {
  const PaymentCountdownBanner({super.key, required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.error100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.error600.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.timer_outlined,
            size: 20.r,
            color: colors.error600,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              tr('checkout.payment_hint'),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: colors.error600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
