import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/features/booking/domain/entities/appointment_filter.dart';
import 'package:zain/features/booking/presentation/cubit/bookings_cubit.dart';

class StatusFilterChips extends StatelessWidget {
  const StatusFilterChips({
    super.key,
    required this.filters,
    required this.selectedIndex,
    required this.colors,
  });

  final List<AppointmentFilter> filters;
  final int selectedIndex;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(filters.length, (index) {
          final filter = filters[index];
          final isSelected = selectedIndex == index;
          return Padding(
            padding: EdgeInsetsDirectional.only(end: 8.w),
            child: GestureDetector(
              onTap: () => context.read<BookingsCubit>().selectFilter(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? splashOrange : colors.neutral100,
                  borderRadius: BorderRadius.circular(999.r),
                  border: Border.all(
                    color: isSelected ? splashOrange : colors.neutral200,
                  ),
                ),
                child: Text(
                  filter.name,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? Colors.white : colors.neutral600,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
