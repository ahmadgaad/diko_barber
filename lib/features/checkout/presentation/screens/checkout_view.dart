import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zain/core/router/app_routes.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/core/widgets/app_gradient_button.dart';
import 'package:zain/features/booking_schedule/domain/entities/created_appointment.dart';
import '../components/checkout_info_row.dart';
import '../components/checkout_service_tile.dart';
import 'package:zain/core/widgets/app_snack_bar.dart';
import 'package:zain/features/booking/presentation/cubit/bookings_cubit.dart';
import '../components/payment_countdown_banner.dart';
import '../components/payment_methods_sheet.dart';
import '../cubit/checkout_cubit.dart';
import '../cubit/checkout_state.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key, required this.appointment});

  final CreatedAppointment appointment;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocListener<CheckoutCubit, CheckoutState>(
      listener: (context, state) async {
        switch (state) {
          case CheckoutPaymentRedirect(:final checkoutUrl, :final returnUrl):
            context.push(AppRoutes.paymentWebview, extra: {
              'checkoutUrl': checkoutUrl,
              'returnUrl': returnUrl,
            });
          case CheckoutPaymentSuccess():
            BookingsCubit.pendingRefresh = true;
            context.go(AppRoutes.bookings);
          case CheckoutPaymentMethodsLoaded(:final payError)
              when payError != null:
            AppSnackBar.show(
              context,
              message: payError,
              type: SnackBarType.error,
            );
          default:
            break;
        }
      },
      child: Scaffold(
        backgroundColor: colors.neutral50,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _TopBar(colors: colors),
              Expanded(
                child: _Content(appointment: appointment, colors: colors),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _BottomBar(
          appointment: appointment,
          colors: colors,
        ),
      ),
    );
  }
}

// ── Top bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.neutral50,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.home);
              }
            },
            child: Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: colors.neutral100,
                shape: BoxShape.circle,
                border: Border.all(color: colors.neutral200),
              ),
              child: Icon(
                Icons.close_rounded,
                size: 18.r,
                color: colors.neutral900,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              tr('checkout.title'),
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

// ── Content ──────────────────────────────────────────────────────────────────

class _Content extends StatelessWidget {
  const _Content({required this.appointment, required this.colors});

  final CreatedAppointment appointment;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final purchase = appointment.purchase;
    final hasCoupon =
        purchase.couponCode != null && purchase.couponAmount > 0;

    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      children: [
        // ── Status badge ─────────────────────────────────────────────
        _StatusBadge(appointment: appointment, colors: colors),
        SizedBox(height: 12.h),

        // ── Payment hint ─────────────────────────────────────────────
        PaymentCountdownBanner(colors: colors),
        SizedBox(height: 20.h),

        // ── Appointment details ──────────────────────────────────────
        _SectionTitle(label: tr('checkout.appointment_details'), colors: colors),
        SizedBox(height: 8.h),
        _DetailsCard(appointment: appointment, colors: colors),
        SizedBox(height: 20.h),

        // ── Services ─────────────────────────────────────────────────
        _SectionTitle(label: tr('checkout.services'), colors: colors),
        SizedBox(height: 8.h),
        ...appointment.services.map(
          (item) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: CheckoutServiceTile(item: item, colors: colors),
          ),
        ),
        SizedBox(height: 12.h),

        // ── Price breakdown ──────────────────────────────────────────
        _SectionTitle(label: tr('checkout.price_breakdown'), colors: colors),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: colors.neutral100,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: colors.neutral200),
          ),
          child: Column(
            children: [
              CheckoutInfoRow(
                label: tr('checkout.subtotal'),
                value: '${purchase.subTotal.toStringAsFixed(2)} ${tr('checkout.currency')}',
                colors: colors,
              ),
              if (hasCoupon) ...[
                SizedBox(height: 10.h),
                CheckoutInfoRow(
                  label: tr(
                    'checkout.coupon_discount',
                    namedArgs: {'code': purchase.couponCode!},
                  ),
                  value: '-${purchase.couponAmount.toStringAsFixed(2)} ${tr('checkout.currency')}',
                  colors: colors,
                  valueColor: Colors.green,
                ),
              ],
              if (purchase.tax > 0) ...[
                SizedBox(height: 10.h),
                CheckoutInfoRow(
                  label: '${tr('checkout.tax')} (${purchase.taxPercentage.toStringAsFixed(0)}%)',
                  value: '${purchase.tax.toStringAsFixed(2)} ${tr('checkout.currency')}',
                  colors: colors,
                ),
              ],
              if (purchase.homeServiceFee > 0) ...[
                SizedBox(height: 10.h),
                CheckoutInfoRow(
                  label: tr('checkout.home_service_fee'),
                  value: '${purchase.homeServiceFee.toStringAsFixed(2)} ${tr('checkout.currency')}',
                  colors: colors,
                ),
              ],
              if (purchase.commissionAmount > 0) ...[
                SizedBox(height: 10.h),
                CheckoutInfoRow(
                  label: '${tr('checkout.commission')} (${purchase.platformCommissionPercentage.toStringAsFixed(0)}%)',
                  value: '${purchase.commissionAmount.toStringAsFixed(2)} ${tr('checkout.currency')}',
                  colors: colors,
                ),
              ],
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Divider(height: 1, color: colors.neutral200),
              ),
              CheckoutInfoRow(
                label: tr('checkout.total'),
                value: '${purchase.totalAmount.toStringAsFixed(2)} ${tr('checkout.currency')}',
                colors: colors,
                isBold: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Status badge ─────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.appointment, required this.colors});

  final CreatedAppointment appointment;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: buttonGradient,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              size: 22.r,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.status.name,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  appointment.code,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section title ────────────────────────────────────────────────────────────

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

// ── Details card ─────────────────────────────────────────────────────────────

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.appointment, required this.colors});

  final CreatedAppointment appointment;
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
          // Salon row
          Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: appointment.salon.logo,
                  width: 40.r,
                  height: 40.r,
                  fit: BoxFit.cover,
                  errorWidget: (_, _, _) => Container(
                    width: 40.r,
                    height: 40.r,
                    color: colors.neutral200,
                    child: Icon(
                      Icons.store_outlined,
                      color: colors.neutral400,
                      size: 20.r,
                    ),
                  ),
                  placeholder: (_, _) => Container(
                    width: 40.r,
                    height: 40.r,
                    color: colors.neutral200,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.salon.name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.neutral900,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      appointment.staff.name,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: colors.neutral500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(height: 1, color: colors.neutral200),
          ),
          CheckoutInfoRow(
            label: tr('checkout.date'),
            value: _formatDate(context, appointment.appointmentDate),
            colors: colors,
          ),
          SizedBox(height: 8.h),
          CheckoutInfoRow(
            label: tr('checkout.time'),
            value:
                '${_formatTime(appointment.startTime)} - ${_formatTime(appointment.endTime)}',
            colors: colors,
          ),
        ],
      ),
    );
  }

  String _formatDate(BuildContext context, String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final locale = context.locale.languageCode;
      return DateFormat('EEEE, d MMM yyyy', locale).format(date);
    } catch (_) {
      return dateStr;
    }
  }

  String _formatTime(String time) {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } catch (_) {
      return time;
    }
  }
}

// ── Bottom bar ───────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.appointment, required this.colors});

  final CreatedAppointment appointment;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16.w, 12.h, 16.w, MediaQuery.paddingOf(context).bottom + 12.h,
      ),
      decoration: BoxDecoration(
        color: colors.neutral50,
        border: Border(top: BorderSide(color: colors.neutral200)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tr('checkout.total'),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.neutral700,
                ),
              ),
              Text(
                '${appointment.purchase.totalAmount.toStringAsFixed(2)} ${tr('checkout.currency')}',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: splashOrange,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          AppGradientButton(
            label: tr('checkout.pay_now'),
            onTap: () => _showPaymentMethods(context),
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: () => context.go(AppRoutes.bookings),
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: colors.neutral100,
                borderRadius: BorderRadius.circular(999.r),
                border: Border.all(color: colors.neutral200),
              ),
              alignment: Alignment.center,
              child: Text(
                tr('checkout.pay_later'),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.neutral700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethods(BuildContext context) {
    final cubit = context.read<CheckoutCubit>()..loadPaymentMethods();
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: PaymentMethodsSheet(
          colors: colors,
          appointmentId: appointment.id,
        ),
      ),
    );
  }
}
