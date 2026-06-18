import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/features/booking_schedule/domain/entities/created_appointment.dart';

class CheckoutServiceTile extends StatelessWidget {
  const CheckoutServiceTile({
    super.key,
    required this.item,
    required this.colors,
  });

  final AppointmentLineItem item;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: Row(
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: splashOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              item.isPackage
                  ? Icons.inventory_2_outlined
                  : Icons.content_cut_rounded,
              size: 18.r,
              color: splashOrange,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.displayName,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.neutral900,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  tr(
                    'checkout.duration_minutes',
                    namedArgs: {'minutes': '${item.durationMinutes}'},
                  ),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: colors.neutral500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${item.subTotal} ${tr('checkout.currency')}',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: colors.neutral800,
            ),
          ),
        ],
      ),
    );
  }
}
