import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zain/core/di/service_locator.dart';
import 'package:zain/core/router/app_routes.dart';
import 'package:zain/core/shared/domain/entities/booking.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/core/widgets/app_gradient_button.dart';
import 'package:zain/core/widgets/app_snack_bar.dart';
import 'package:zain/features/booking/domain/use_cases/cancel_appointment_use_case.dart';
import 'package:zain/features/booking/presentation/components/booking_status_badge.dart';
import 'package:zain/features/booking/presentation/components/cancel_booking_dialog.dart';
import 'package:zain/features/booking/presentation/components/rate_salon_dialog.dart';
import 'package:zain/features/booking/presentation/cubit/bookings_cubit.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key, required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.neutral50,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopBar(colors: colors),
            Expanded(
              child: _Content(booking: booking, colors: colors),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomActions(booking: booking, colors: colors),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: colors.neutral100,
                shape: BoxShape.circle,
                border: Border.all(color: colors.neutral200),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 18.r,
                color: colors.neutral900,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              tr('booking_details.title'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: colors.neutral900,
              ),
            ),
          ),
          SizedBox(width: 38.r),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.booking, required this.colors});

  final Booking booking;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 50.h),
      children: [
        _StatusHeader(booking: booking, colors: colors),
        SizedBox(height: 20.h),
        _SectionTitle(label: tr('booking_details.salon_info'), colors: colors),
        SizedBox(height: 8.h),
        _SalonCard(booking: booking, colors: colors),
        SizedBox(height: 20.h),
        _SectionTitle(
          label: tr('booking_details.appointment_info'),
          colors: colors,
        ),
        SizedBox(height: 8.h),
        _InfoCard(
          colors: colors,
          children: [
            _InfoRow(
              icon: Icons.calendar_today_outlined,
              label: tr('booking_details.date'),
              value: _formatDate(booking.appointmentDate, locale),
              colors: colors,
            ),
            _InfoRow(
              icon: Icons.access_time_rounded,
              label: tr('booking_details.time'),
              value:
                  '${booking.startTime.substring(0, 5)} - ${booking.endTime.substring(0, 5)}',
              colors: colors,
            ),
            _InfoRow(
              icon: Icons.store_outlined,
              label: tr('booking_details.type'),
              value: booking.bookingType.name,
              colors: colors,
            ),
            if (booking.staff != null)
              _InfoRow(
                icon: Icons.person_outline,
                label: tr('booking_details.barber'),
                value: booking.staff!.name,
                colors: colors,
              ),
          ],
        ),
        SizedBox(height: 20.h),

        _SectionTitle(label: tr('booking_details.services'), colors: colors),
        SizedBox(height: 8.h),
        _ServicesCard(booking: booking, colors: colors),

        if (booking.purchase != null) ...[
          SizedBox(height: 20.h),
          _SectionTitle(
            label: tr('booking_details.price_breakdown'),
            colors: colors,
          ),
          SizedBox(height: 8.h),
          _PriceCard(purchase: booking.purchase!, colors: colors),
        ],

        if (booking.notes != null) ...[
          SizedBox(height: 20.h),
          _SectionTitle(label: tr('booking_details.notes'), colors: colors),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: colors.neutral100,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: colors.neutral200),
            ),
            child: Text(
              booking.notes!,
              style: TextStyle(fontSize: 13.sp, color: colors.neutral700),
            ),
          ),
        ],
      ],
    );
  }

  String _formatDate(String dateStr, String locale) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('EEEE, d MMM yyyy', locale).format(date);
    } catch (_) {
      return dateStr;
    }
  }
}

class _StatusHeader extends StatelessWidget {
  const _StatusHeader({required this.booking, required this.colors});
  final Booking booking;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.code,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.neutral700,
                  ),
                ),
                SizedBox(height: 4.h),
                BookingStatusBadge(
                  statusId: booking.statusId,
                  statusName: booking.statusName,
                  colors: colors,
                ),
              ],
            ),
          ),
          if (booking.purchase != null)
            Text(
              '${booking.purchase!.totalAmount.toStringAsFixed(2)} ${tr('home.currency')}',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: splashOrange,
              ),
            ),
        ],
      ),
    );
  }
}

class _SalonCard extends StatelessWidget {
  const _SalonCard({required this.booking, required this.colors});
  final Booking booking;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: CachedNetworkImage(
              imageUrl: booking.salon.logo,
              width: 48.r,
              height: 48.r,
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(
                width: 48.r,
                height: 48.r,
                color: colors.neutral200,
              ),
              errorWidget: (_, _, _) => Container(
                width: 48.r,
                height: 48.r,
                color: colors.neutral200,
                child: Icon(Icons.store_outlined, color: colors.neutral400),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.salon.name,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.neutral900,
                  ),
                ),
                if (booking.salon.location != null) ...[
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 13.r,
                        color: colors.neutral400,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          booking.salon.location!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: colors.neutral500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServicesCard extends StatelessWidget {
  const _ServicesCard({required this.booking, required this.colors});
  final Booking booking;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: Column(
        children: [
          for (var i = 0; i < booking.services.length; i++) ...[
            if (i > 0) ...[
              SizedBox(height: 8.h),
              Divider(height: 1, color: colors.neutral200),
              SizedBox(height: 8.h),
            ],
            Row(
              children: [
                Icon(
                  Icons.content_cut_rounded,
                  size: 15.r,
                  color: colors.neutral400,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.services[i].serviceName ??
                            booking.services[i].packageName ??
                            booking.services[i].categoryName,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.neutral800,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        tr(
                          'checkout.duration_minutes',
                          namedArgs: {
                            'minutes': '${booking.services[i].durationMinutes}',
                          },
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
                  '${booking.services[i].subTotal.toStringAsFixed(0)} ${tr('home.currency')}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.neutral900,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PriceCard extends StatelessWidget {
  const _PriceCard({required this.purchase, required this.colors});
  final BookingPurchase purchase;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final hasCoupon = purchase.couponCode != null && purchase.couponAmount > 0;
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: Column(
        children: [
          _PriceRow(
            label: tr('checkout.subtotal'),
            value:
                '${purchase.subTotal.toStringAsFixed(2)} ${tr('checkout.currency')}',
            colors: colors,
          ),
          if (hasCoupon) ...[
            SizedBox(height: 10.h),
            _PriceRow(
              label: tr(
                'checkout.coupon_discount',
                namedArgs: {'code': purchase.couponCode!},
              ),
              value:
                  '-${purchase.couponAmount.toStringAsFixed(2)} ${tr('checkout.currency')}',
              colors: colors,
              valueColor: Colors.green,
            ),
          ],
          if (purchase.tax > 0) ...[
            SizedBox(height: 10.h),
            _PriceRow(
              label:
                  '${tr('checkout.tax')} (${purchase.taxPercentage.toStringAsFixed(0)}%)',
              value:
                  '${purchase.tax.toStringAsFixed(2)} ${tr('checkout.currency')}',
              colors: colors,
            ),
          ],
          if (purchase.commissionAmount > 0) ...[
            SizedBox(height: 10.h),
            _PriceRow(
              label:
                  '${tr('checkout.commission')} (${purchase.platformCommissionPercentage.toStringAsFixed(0)}%)',
              value:
                  '${purchase.commissionAmount.toStringAsFixed(2)} ${tr('checkout.currency')}',
              colors: colors,
            ),
          ],
          if (purchase.homeServiceFee > 0) ...[
            SizedBox(height: 10.h),
            _PriceRow(
              label: tr('checkout.home_service_fee'),
              value:
                  '${purchase.homeServiceFee.toStringAsFixed(2)} ${tr('checkout.currency')}',
              colors: colors,
            ),
          ],
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Divider(height: 1, color: colors.neutral200),
          ),
          _PriceRow(
            label: tr('checkout.total'),
            value:
                '${purchase.totalAmount.toStringAsFixed(2)} ${tr('checkout.currency')}',
            colors: colors,
            isBold: true,
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
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
            fontSize: 13.sp,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: colors.neutral600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color:
                valueColor ?? (isBold ? colors.neutral900 : colors.neutral700),
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.colors, required this.children});
  final AppColors colors;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: 10.h),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.colors,
  });

  final IconData icon;
  final String label;
  final String value;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.r, color: colors.neutral400),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(fontSize: 13.sp, color: colors.neutral500),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: colors.neutral800,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label, required this.colors});
  final String label;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        color: colors.neutral900,
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({required this.booking, required this.colors});
  final Booking booking;
  final AppColors colors;

  Future<void> _handleCancel(BuildContext context) async {
    final reason = await CancelBookingDialog.show(context, colors);
    if (reason == null || !context.mounted) return;

    final result = await sl<CancelAppointmentUseCase>()(
      appointmentId: booking.id,
      reason: reason,
    );

    if (!context.mounted) return;

    result.when(
      success: (_) {
        BookingsCubit.pendingRefresh = true;
        AppSnackBar.show(
          context,
          message: tr('bookings.cancel_success'),
          type: SnackBarType.success,
        );
        context.pop();
      },
      failure: (error) => AppSnackBar.show(
        context,
        message: error.message,
        type: SnackBarType.error,
      ),
    );
  }

  Future<void> _handleRate(BuildContext context) async {
    final result = await RateSalonDialog.show(
      context,
      colors,
      salonName: booking.salon.name,
    );
    if (result == null || !context.mounted) return;

    // TODO: submit via a RateSalonUseCase once the rating endpoint is available
    // — uses booking.salon.id, result.rating, result.comment.
    AppSnackBar.show(
      context,
      message: tr('bookings.rate_success'),
      type: SnackBarType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!booking.actions.hasAny) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.fromLTRB(
        16.w, 12.h, 16.w, MediaQuery.paddingOf(context).bottom + 12.h,
      ),
      decoration: BoxDecoration(
        color: colors.neutral50,
        border: Border(top: BorderSide(color: colors.neutral200)),
      ),
      child: Row(
        children: [
          if (booking.actions.canCancel)
            Expanded(
              child: _OutlinedButton(
                label: tr('bookings.cancel'),
                colors: colors,
                onTap: () => _handleCancel(context),
              ),
            ),
          if (booking.actions.canCancel && booking.actions.canPay)
            SizedBox(width: 10.w),
          if (booking.actions.canPay)
            Expanded(
              child: AppGradientButton(
                label: tr('bookings.pay'),
                onTap: () => context.push(
                  AppRoutes.checkout,
                  extra: booking.toCreatedAppointment(),
                ),
              ),
            ),
          if (booking.actions.canComplete)
            Expanded(
              child: AppGradientButton(
                label: tr('bookings.rate_salon'),
                onTap: () => _handleRate(context),
              ),
            ),
        ],
      ),
    );
  }
}

class _OutlinedButton extends StatelessWidget {
  const _OutlinedButton({
    required this.label,
    required this.colors,
    required this.onTap,
  });

  final String label;
  final AppColors colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(color: colors.neutral300),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: colors.neutral700,
          ),
        ),
      ),
    );
  }
}
