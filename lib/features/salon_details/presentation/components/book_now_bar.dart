import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zain/core/router/app_routes.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/core/widgets/app_gradient_button.dart';
import 'package:zain/core/widgets/auth_gate.dart';
import 'package:zain/features/booking_schedule/presentation/booking_schedule_args.dart';
import 'package:zain/features/salon_details/presentation/cubit/salon_details_cubit.dart';
import 'package:zain/features/salon_details/presentation/cubit/salon_details_state.dart';

class BookNowBar extends StatelessWidget {
  const BookNowBar({
    super.key,
    required this.salonId,
    required this.salonName,
    required this.colors,
  });

  final int salonId;
  final String salonName;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalonDetailsCubit, SalonDetailsState>(
      builder: (context, state) {
        final loaded = state is SalonDetailsLoaded ? state : null;
        final couponCode = loaded?.couponCode;
        final serviceIds = loaded?.selectedServiceIds ?? const {};
        final packageIds = loaded?.selectedPackageIds ?? const {};
        final hasSelection = serviceIds.isNotEmpty || packageIds.isNotEmpty;

        return Container(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          decoration: BoxDecoration(
            color: colors.neutral50,
            border: Border(top: BorderSide(color: colors.neutral200)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Coupon applied banner
              if (couponCode != null) ...[
                Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: splashOrange.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: splashOrange.withValues(alpha: 0.30),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_offer_outlined,
                        size: 16.r,
                        color: splashOrange,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          tr('salon_details.coupon_applied'),
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: splashOrange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: splashOrange,
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Text(
                          couponCode,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              AppGradientButton(
                label: tr('salon_details.book_now'),
                enabled: hasSelection,
                onTap: () => AuthGate.guard(
                  context,
                  () => context.push(
                    AppRoutes.bookingSchedule,
                    extra: BookingScheduleArgs(
                      salonId: salonId,
                      salonName: salonName,
                      couponCode: couponCode,
                      serviceIds: serviceIds,
                      packageIds: packageIds,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
