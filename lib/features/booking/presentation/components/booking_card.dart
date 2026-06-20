import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zain/core/router/app_routes.dart';
import 'package:zain/core/shared/domain/entities/booking.dart';
import 'package:zain/core/theme/app_colors.dart';

import 'booking_action_button.dart';
import 'booking_salon_logo.dart';
import 'booking_status_badge.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({super.key, required this.booking, required this.colors});

  final Booking booking;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.bookingDetails, extra: booking),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: colors.neutral100,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: colors.neutral200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                BookingSalonLogo(url: booking.salon.logo, colors: colors),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.salon.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.neutral900,
                        ),
                      ),
                      if (booking.staff != null) ...[
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 12.r,
                              color: colors.neutral400,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              booking.staff!.name,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: colors.neutral500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                BookingStatusBadge(
                  statusId: booking.statusId,
                  statusName: booking.statusName,
                  colors: colors,
                ),
              ],
            ),

            SizedBox(height: 12.h),
            Divider(color: colors.neutral200, height: 1),
            SizedBox(height: 12.h),

            Row(
              children: [
                Icon(
                  Icons.content_cut_rounded,
                  size: 15.r,
                  color: colors.neutral400,
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    booking.servicesDisplay,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: colors.neutral800,
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
                Text(
                  '${booking.totalAmount.toInt()} ${tr('home.currency')}',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: splashOrange,
                  ),
                ),
              ],
            ),

            SizedBox(height: 8.h),

            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 13.r,
                  color: colors.neutral400,
                ),
                SizedBox(width: 6.w),
                Text(
                  _formatDateTime(context),
                  style: TextStyle(fontSize: 12.sp, color: colors.neutral500),
                ),
              ],
            ),

            if (booking.salon.location != null) ...[
              SizedBox(height: 6.h),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 13.r,
                    color: colors.neutral400,
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      booking.salon.location!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 12.sp, color: colors.neutral500),
                    ),
                  ),
                ],
              ),
            ],

            if (!booking.actions.canPay) ...[
              SizedBox(height: 8.h),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 18.r,
                  color: colors.neutral400,
                ),
              ),
            ],

            if (booking.actions.canPay) ...[
              SizedBox(height: 12.h),
              BookingActionButton(
                label: tr('bookings.pay'),
                isPrimary: true,
                onTap: () => context.push(
                  AppRoutes.checkout,
                  extra: booking.toCreatedAppointment(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDateTime(BuildContext context) {
    try {
      final date = DateTime.parse(booking.appointmentDate);
      final locale = context.locale.languageCode;
      final formatted = DateFormat('EEEE, d MMM yyyy', locale).format(date);
      final time = booking.startTime.substring(0, 5);
      return '$formatted · $time';
    } catch (_) {
      return '${booking.appointmentDate} · ${booking.startTime.substring(0, 5)}';
    }
  }
}
