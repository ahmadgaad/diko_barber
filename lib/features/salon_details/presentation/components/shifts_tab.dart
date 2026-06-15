import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/features/salon_details/domain/entities/shift.dart';
import 'package:zain/features/salon_details/presentation/components/empty_tab.dart';

class ShiftsTab extends StatelessWidget {
  const ShiftsTab({super.key, required this.shifts, required this.colors});

  final List<Shift> shifts;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    if (shifts.isEmpty) {
      return EmptyTab(
        icon: Icons.schedule_rounded,
        message: tr('salon_details.no_shifts'),
        colors: colors,
      );
    }
    final ordered = [...shifts]..sort((a, b) => a.dayWeek.compareTo(b.dayWeek));
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      physics: const BouncingScrollPhysics(),
      itemCount: ordered.length,
      separatorBuilder: (_, _) => SizedBox(height: 8.h),
      itemBuilder: (context, i) => _ShiftRow(shift: ordered[i], colors: colors),
    );
  }
}

class _ShiftRow extends StatelessWidget {
  const _ShiftRow({required this.shift, required this.colors});

  final Shift shift;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: Row(
        children: [
          Container(
            width: 8.r,
            height: 8.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: shift.isActive ? colors.success500 : colors.neutral400,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              shift.dayName,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: colors.neutral900,
              ),
            ),
          ),
          if (shift.isActive)
            Text(
              '${shift.from} - ${shift.to}',
              style: TextStyle(fontSize: 12.sp, color: colors.neutral600),
            )
          else
            Text(
              tr('home.closed'),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: colors.error500,
              ),
            ),
        ],
      ),
    );
  }
}
