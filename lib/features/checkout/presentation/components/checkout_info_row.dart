import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';

class CheckoutInfoRow extends StatelessWidget {
  const CheckoutInfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.colors,
    this.isBold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final AppColors colors;
  final bool isBold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 13.sp : 12.sp,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: isBold ? colors.neutral900 : colors.neutral500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 15.sp : 13.sp,
            fontWeight: FontWeight.w700,
            color: valueColor ?? (isBold ? splashOrange : colors.neutral800),
          ),
        ),
      ],
    );
  }
}
