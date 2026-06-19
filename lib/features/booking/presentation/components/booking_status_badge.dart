import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';

class BookingStatusBadge extends StatelessWidget {
  const BookingStatusBadge({
    super.key,
    required this.statusId,
    required this.statusName,
    required this.colors,
  });

  final int statusId;
  final String statusName;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _statusColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        statusName,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }

  (Color, Color) get _statusColors => switch (statusId) {
        0 => (colors.warning100, colors.warning600),
        2 => (colors.info100, colors.info600),
        6 => (colors.info100, colors.info600),
        9 => (colors.success100, colors.success600),
        13 => (colors.info100, colors.info600),
        _ => (colors.error100, colors.error600),
      };
}
