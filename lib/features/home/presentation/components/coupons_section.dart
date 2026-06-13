import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ronaq_barber/core/router/app_routes.dart';
import 'package:ronaq_barber/core/shared/domain/entities/coupon.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/core/widgets/app_gradient_button.dart';
import 'package:ronaq_barber/core/widgets/app_snack_bar.dart';
import 'package:ronaq_barber/features/book_appointment/presentation/book_appointment_args.dart';
import 'package:ronaq_barber/features/home/presentation/components/section_header.dart';
import 'package:ronaq_barber/features/salon_details/presentation/screens/salon_details_args.dart';
import 'package:ronaq_barber/features/home/presentation/cubit/coupons_cubit.dart';
import 'package:ronaq_barber/features/home/presentation/cubit/coupons_state.dart';
import 'package:shimmer/shimmer.dart';

class CouponsSection extends StatelessWidget {
  const CouponsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocBuilder<CouponsCubit, CouponsState>(
      builder: (context, state) => switch (state) {
        CouponsLoading() => _CouponsShimmer(colors: colors),
        CouponsLoaded(:final coupons) when coupons.isEmpty =>
          const SizedBox.shrink(),
        CouponsLoaded(:final coupons) => _CouponsList(
          coupons: coupons,
          colors: colors,
        ),
        CouponsError() => const SizedBox.shrink(),
      },
    );
  }
}

// ── List ──────────────────────────────────────────────────────────────────────

class _CouponsList extends StatelessWidget {
  const _CouponsList({required this.coupons, required this.colors});
  final List<Coupon> coupons;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SectionHeader(titleKey: 'home.weekly_coupons', colors: colors),
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: coupons.map((c) {
              return Padding(
                padding: EdgeInsetsDirectional.only(end: 16.w),
                child: CouponCard(coupon: c),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 14.h),
      ],
    );
  }
}

// ── Coupon card ───────────────────────────────────────────────────────────────
//
// Simplified ticket — stub on the right holds the discount %, body shows name
// + applies-to + salon. An info icon + InkWell ripple signal the card is
// tappable; tapping opens the full-detail bottom sheet.

class CouponCard extends StatelessWidget {
  const CouponCard({super.key, required this.coupon, this.width});
  final Coupon coupon;

  /// Card width. Defaults to the horizontal-carousel size used on home.
  final double? width;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textDirection = Directionality.of(context);
    final cardW = width ?? 280.w;
    final cardH = 100.h;
    final stubW = 88.w;
    final notchR = 11.r;
    final cornerR = 16.r;
    final perforationX = cardW - stubW;

    return SizedBox(
      width: cardW,
      height: cardH,
      child: Stack(
        children: [
          // Shadow + fills outside clip so shadow bleeds naturally
          CustomPaint(
            size: Size(cardW, cardH),
            painter: _TicketBgPainter(
              perforationX: perforationX,
              notchR: notchR,
              cornerR: cornerR,
              bodyColor: colors.neutral100,
              borderColor: colors.neutral200,
            ),
          ),

          // Content clipped to ticket shape; Material enables InkWell ripple
          ClipPath(
            clipper: _TicketClipper(
              perforationX: perforationX,
              notchR: notchR,
              cornerR: cornerR,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showCouponDetailSheet(context, coupon),
                splashColor: splashOrange.withValues(alpha: 0.10),
                highlightColor: splashOrange.withValues(alpha: 0.06),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: SizedBox(
                    width: cardW,
                    height: cardH,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Directionality(
                            textDirection: textDirection,
                            child: _TicketBody(coupon: coupon, colors: colors),
                          ),
                        ),
                        _DiscountStub(width: stubW, coupon: coupon),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stub (orange gradient, big amount) ───────────────────────────────────────

class _DiscountStub extends StatelessWidget {
  const _DiscountStub({required this.width, required this.coupon});
  final double width;
  final Coupon coupon;

  @override
  Widget build(BuildContext context) {
    final amountText = coupon.isPercentage
        ? '${coupon.amount.toInt()}%'
        : '${coupon.amount.toInt()}';

    return Container(
      width: width,
      decoration: const BoxDecoration(gradient: buttonGradient),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            amountText,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.0,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            coupon.isPercentage ? tr('home.off') : coupon.typeLabel,
            style: TextStyle(
              fontSize: coupon.isPercentage ? 12.sp : 9.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.9),
              letterSpacing: coupon.isPercentage ? 2.0 : 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Simplified body ───────────────────────────────────────────────────────────

class _TicketBody extends StatelessWidget {
  const _TicketBody({required this.coupon, required this.colors});
  final Coupon coupon;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.neutral100,
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 12.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name row + info icon signalling the card is tappable
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  coupon.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.neutral900,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              Icon(
                Icons.info_outline_rounded,
                size: 15.r,
                color: splashOrange,
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            coupon.appliesTo.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.sp,
              color: colors.neutral500,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              _SalonLogo(url: coupon.salon.image, colors: colors),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  coupon.salon.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.neutral500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Detail bottom sheet ───────────────────────────────────────────────────────

// Routes Claim Now based on what the coupon applies to:
//   1 = ALL              → salon details (general)
//   2 = SERVICES         → book appointment
//   3 = PACKAGES         → salon details, packages tab pre-selected
//   4 = SERVICES_AND_PACKAGES → book appointment
void _navigateForAppliesTo({
  required BuildContext context,
  required Coupon coupon,
}) {
  final appliesToId = coupon.appliesTo.id;

  if (appliesToId == 2 || appliesToId == 4) {
    context.push(
      AppRoutes.bookAppointment,
      extra: BookAppointmentArgs(
        salonId: coupon.salon.id,
        salonName: coupon.salon.name,
        couponCode: coupon.code,
      ),
    );
  } else {
    // 1 = ALL → services tab (0); 3 = PACKAGES → packages tab (1)
    context.push(
      '/salon/${coupon.salon.id}',
      extra: SalonDetailsArgs(
        couponCode: coupon.code,
        initialTab: appliesToId == 3 ? 1 : 0,
      ),
    );
  }
}

void _showCouponDetailSheet(BuildContext context, Coupon coupon) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _CouponDetailSheet(coupon: coupon, rootContext: context),
  );
}

class _CouponDetailSheet extends StatelessWidget {
  const _CouponDetailSheet({required this.coupon, required this.rootContext});
  final Coupon coupon;
  final BuildContext rootContext;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final locale = context.locale.languageCode;
    final dateFormat = DateFormat('dd MMM yyyy', locale);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: colors.neutral50,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          children: [
            // Drag handle
            Padding(
              padding: EdgeInsets.only(top: 12.h, bottom: 4.h),
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colors.neutral300,
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
            ),

            Expanded(
              child: ListView(
                controller: controller,
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
                children: [
                  // ── Header card ────────────────────────────────────────────
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      gradient: buttonGradient,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                coupon.name,
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                coupon.appliesTo.name,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            children: [
                              Text(
                                coupon.isPercentage
                                    ? '${coupon.amount.toInt()}%'
                                    : '${coupon.amount.toInt()}',
                                style: TextStyle(
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  height: 1.0,
                                ),
                              ),
                              Text(
                                coupon.isPercentage
                                    ? tr('home.off')
                                    : coupon.typeLabel,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white.withValues(alpha: 0.9),
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // ── Coupon code ────────────────────────────────────────────
                  Text(
                    tr('home.coupon_code'),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.neutral500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: colors.neutral100,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: colors.neutral200),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            coupon.code,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w800,
                              color: colors.neutral900,
                              letterSpacing: 3,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await Clipboard.setData(
                              ClipboardData(text: coupon.code),
                            );
                            if (!rootContext.mounted) return;
                            AppSnackBar.show(
                              rootContext,
                              message: tr('home.code_copied'),
                              type: SnackBarType.success,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: splashOrange.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.copy_rounded,
                                  size: 14.r,
                                  color: splashOrange,
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  tr('home.copy'),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: splashOrange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // ── Salon ──────────────────────────────────────────────────
                  Text(
                    tr('home.salon'),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.neutral500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Material(
                    color: colors.neutral100,
                    borderRadius: BorderRadius.circular(12.r),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        rootContext.push('/salon/${coupon.salon.id}');
                      },
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: colors.neutral200),
                    ),
                    child: Row(
                      children: [
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: coupon.salon.image,
                            width: 44.r,
                            height: 44.r,
                            fit: BoxFit.cover,
                            errorWidget: (_, _, _) => Container(
                              width: 44.r,
                              height: 44.r,
                              color: colors.neutral200,
                              child: Icon(
                                Icons.store_outlined,
                                color: colors.neutral400,
                                size: 22.r,
                              ),
                            ),
                            placeholder: (_, _) => Container(
                              width: 44.r,
                              height: 44.r,
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
                                coupon.salon.name,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: colors.neutral900,
                                ),
                              ),
                              if (coupon.salon.location != null ||
                                  coupon.salon.distance != null) ...[
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    if (coupon.salon.location != null) ...[
                                      Icon(
                                        Icons.location_on_outlined,
                                        size: 12.r,
                                        color: colors.neutral400,
                                      ),
                                      SizedBox(width: 3.w),
                                      Expanded(
                                        child: Text(
                                          coupon.salon.location!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: colors.neutral500,
                                          ),
                                        ),
                                      ),
                                    ],
                                    if (coupon.salon.distance != null) ...[
                                      SizedBox(width: 8.w),
                                      Text(
                                        '${coupon.salon.distance!.value.toStringAsFixed(1)} ${coupon.salon.distance!.unit}',
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                          color: splashOrange,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14.r,
                          color: colors.neutral400,
                        ),
                      ],
                    ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // ── Details ────────────────────────────────────────────────
                  Text(
                    tr('home.details'),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.neutral500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    decoration: BoxDecoration(
                      color: colors.neutral100,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: colors.neutral200),
                    ),
                    child: Column(
                      children: [
                        _DetailRow(
                          icon: Icons.category_outlined,
                          label: tr('home.applies_to'),
                          value: coupon.appliesTo.name,
                          colors: colors,
                          isFirst: true,
                        ),
                        if (coupon.startDate != null)
                          _DetailRow(
                            icon: Icons.calendar_today_outlined,
                            label: tr('home.valid_from'),
                            value: dateFormat.format(coupon.startDate!),
                            colors: colors,
                          ),
                        _DetailRow(
                          icon: Icons.timer_outlined,
                          label: tr('home.valid_until_label'),
                          value: dateFormat.format(coupon.endDate),
                          colors: colors,
                        ),
                        if (coupon.remainingUsage != null)
                          _DetailRow(
                            icon: Icons.confirmation_number_outlined,
                            label: tr('home.remaining_uses'),
                            value: tr(
                              'home.uses_left',
                              namedArgs: {'count': '${coupon.remainingUsage}'},
                            ),
                            colors: colors,
                          ),
                        if (coupon.maxDiscountAmount != null)
                          _DetailRow(
                            icon: Icons.money_off_outlined,
                            label: tr('home.max_discount'),
                            value:
                                '${coupon.maxDiscountAmount!.toStringAsFixed(0)} ${tr('home.currency')}',
                            colors: colors,
                            isLast: true,
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: 28.h),

                  // ── CTA ────────────────────────────────────────────────────
                  AppGradientButton(
                    label: tr('home.claim_now'),
                    onTap: () {
                      Navigator.of(context).pop();
                      _navigateForAppliesTo(
                        context: rootContext,
                        coupon: coupon,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Detail row ────────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.colors,
    this.isFirst = false,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final AppColors colors;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!isFirst)
          Divider(height: 1, thickness: 1, color: colors.neutral200),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              Icon(icon, size: 15.r, color: colors.neutral400),
              SizedBox(width: 10.w),
              Text(
                label,
                style: TextStyle(fontSize: 12.sp, color: colors.neutral500),
              ),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.neutral900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Salon logo (card) ─────────────────────────────────────────────────────────

class _SalonLogo extends StatelessWidget {
  const _SalonLogo({required this.url, required this.colors});
  final String url;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url,
        width: 18.r,
        height: 18.r,
        fit: BoxFit.cover,
        errorWidget: (_, _, _) => Container(
          width: 18.r,
          height: 18.r,
          color: colors.neutral200,
          child: Icon(
            Icons.store_outlined,
            color: colors.neutral400,
            size: 11.r,
          ),
        ),
        placeholder: (_, _) =>
            Container(width: 18.r, height: 18.r, color: colors.neutral200),
      ),
    );
  }
}

// ── Background painter ────────────────────────────────────────────────────────

class _TicketBgPainter extends CustomPainter {
  const _TicketBgPainter({
    required this.perforationX,
    required this.notchR,
    required this.cornerR,
    required this.bodyColor,
    required this.borderColor,
  });

  final double perforationX;
  final double notchR;
  final double cornerR;
  final Color bodyColor;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _ticketPath(
      width: size.width,
      height: size.height,
      perforationX: perforationX,
      notchR: notchR,
      cornerR: cornerR,
    );

    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.25), 10, false);
    canvas.drawPath(path, Paint()..color = bodyColor);
    canvas.drawPath(
      path,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Orange dashed perforation between stub and body
    final dashPaint = Paint()
      ..color = splashOrange.withValues(alpha: 0.55)
      ..strokeWidth = 1.4;
    const dashH = 5.0;
    const gapH = 4.5;
    double y = notchR + 7;
    final maxY = size.height - notchR - 7;
    while (y < maxY) {
      canvas.drawLine(
        Offset(perforationX, y),
        Offset(perforationX, math.min(y + dashH, maxY)),
        dashPaint,
      );
      y += dashH + gapH;
    }
  }

  @override
  bool shouldRepaint(_TicketBgPainter old) =>
      old.perforationX != perforationX ||
      old.notchR != notchR ||
      old.cornerR != cornerR ||
      old.bodyColor != bodyColor ||
      old.borderColor != borderColor;
}

// ── Clipper ───────────────────────────────────────────────────────────────────

class _TicketClipper extends CustomClipper<Path> {
  const _TicketClipper({
    required this.perforationX,
    required this.notchR,
    required this.cornerR,
  });

  final double perforationX;
  final double notchR;
  final double cornerR;

  @override
  Path getClip(Size size) => _ticketPath(
    width: size.width,
    height: size.height,
    perforationX: perforationX,
    notchR: notchR,
    cornerR: cornerR,
  );

  @override
  bool shouldReclip(_TicketClipper old) =>
      old.perforationX != perforationX ||
      old.notchR != notchR ||
      old.cornerR != cornerR;
}

// ── Shared path builder ───────────────────────────────────────────────────────

Path _ticketPath({
  required double width,
  required double height,
  required double perforationX,
  required double notchR,
  required double cornerR,
}) {
  final path = Path();
  final r = cornerR;
  final nr = notchR;

  path.moveTo(r, 0);
  path.lineTo(perforationX - nr, 0);
  path.arcToPoint(
    Offset(perforationX + nr, 0),
    radius: Radius.circular(nr),
    clockwise: false,
  );
  path.lineTo(width - r, 0);
  path.arcToPoint(Offset(width, r), radius: Radius.circular(r));

  path.lineTo(width, height - r);
  path.arcToPoint(Offset(width - r, height), radius: Radius.circular(r));

  path.lineTo(perforationX + nr, height);
  path.arcToPoint(
    Offset(perforationX - nr, height),
    radius: Radius.circular(nr),
    clockwise: false,
  );
  path.lineTo(r, height);
  path.arcToPoint(Offset(0, height - r), radius: Radius.circular(r));

  path.lineTo(0, r);
  path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
  path.close();

  return path;
}

// ── Shimmer ───────────────────────────────────────────────────────────────────

class _CouponsShimmer extends StatelessWidget {
  const _CouponsShimmer({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: colors.neutral200,
            highlightColor: colors.neutral100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 130.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: colors.neutral200,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                Container(
                  width: 70.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: colors.neutral200,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Shimmer.fromColors(
            baseColor: colors.neutral200,
            highlightColor: colors.neutral100,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                children: List.generate(2, (_) {
                  return Padding(
                    padding: EdgeInsetsDirectional.only(end: 16.w),
                    child: _CouponCardSkeleton(colors: colors),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CouponCardSkeleton extends StatelessWidget {
  const _CouponCardSkeleton({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    final cardW = 280.w;
    final cardH = 100.h;
    final stubW = 88.w;

    return ClipPath(
      clipper: _TicketClipper(
        perforationX: cardW - stubW,
        notchR: 11.r,
        cornerR: 16.r,
      ),
      child: SizedBox(
        width: cardW,
        height: cardH,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Directionality(
                  textDirection: textDirection,
                  child: Container(
                    color: colors.neutral200.withValues(alpha: 0.45),
                    padding: EdgeInsets.fromLTRB(14.w, 12.h, 12.w, 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _SkeletonBox(
                                width: double.infinity,
                                height: 14.h,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            _SkeletonBox(
                              width: 15.r,
                              height: 15.r,
                              radius: 999,
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        _SkeletonBox(width: 80.w, height: 10.h),
                        const Spacer(),
                        _SkeletonBox(width: 100.w, height: 10.h),
                      ],
                    ),
                  ),
                ),
              ),
              Container(width: stubW, color: colors.neutral200),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    this.radius = 6,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      width: width == double.infinity ? null : width,
      height: height,
      decoration: BoxDecoration(
        color: colors.neutral200,
        borderRadius: BorderRadius.circular(radius.r),
      ),
    );
  }
}
