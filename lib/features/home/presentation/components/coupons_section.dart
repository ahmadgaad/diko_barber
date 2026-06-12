import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/shared/domain/entities/coupon.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/features/home/presentation/components/section_header.dart';
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
// Luxury ticket:
//   • Orange gradient stub on the left holding the big discount %.
//   • Theme-adaptive body (elevated surface) with service, salon, validity.
//   • Notches at the stub/body junction + orange dashed perforation.
//   • "Claim Now →" orange pill bottom-right.
//
// Always LTR — a printed ticket does not mirror with locale.

class CouponCard extends StatelessWidget {
  const CouponCard({super.key, required this.coupon});
  final Coupon coupon;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final cardW = 310.w;
    final cardH = 120.h;
    final stubW = 96.w;
    final notchR = 11.r;
    final cornerR = 16.r;

    return SizedBox(
      width: cardW,
      height: cardH,
      child: Stack(
        children: [
          // ── Layer 1: shadow + fills (unclipped so shadow bleeds out) ─────
          CustomPaint(
            size: Size(cardW, cardH),
            painter: _TicketBgPainter(
              stubW: stubW,
              notchR: notchR,
              cornerR: cornerR,
              bodyColor: colors.neutral100,
              borderColor: colors.neutral200,
            ),
          ),

          // ── Layer 2: content clipped to the ticket shape ─────────────────
          ClipPath(
            clipper: _TicketClipper(
              stubW: stubW,
              notchR: notchR,
              cornerR: cornerR,
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: SizedBox(
                width: cardW,
                height: cardH,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _DiscountStub(
                      width: stubW,
                      discountPercent: coupon.discountPercent,
                    ),
                    Expanded(
                      child: _TicketBody(coupon: coupon, colors: colors),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stub (orange gradient, big %) ─────────────────────────────────────────────

class _DiscountStub extends StatelessWidget {
  const _DiscountStub({required this.width, required this.discountPercent});
  final double width;
  final int discountPercent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: const BoxDecoration(gradient: buttonGradient),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$discountPercent%',
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.0,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            tr('home.off'),
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.9),
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Body (dark, info + CTA) ───────────────────────────────────────────────────

class _TicketBody extends StatelessWidget {
  const _TicketBody({required this.coupon, required this.colors});
  final Coupon coupon;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.neutral100,
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 14.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            coupon.serviceLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: colors.neutral900,
            ),
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              _SalonLogo(url: coupon.salonLogo, colors: colors),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  coupon.salonName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.neutral500,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Icon(Icons.timer_outlined, size: 13.r, color: colors.neutral400),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  tr(
                    'home.valid_until',
                    namedArgs: {
                      'date': DateFormat(
                        'dd MMM yyyy',
                        context.locale.languageCode,
                      ).format(coupon.expiresAt),
                    },
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: colors.neutral400,
                  ),
                ),
              ),
              _ClaimButton(onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class _ClaimButton extends StatelessWidget {
  const _ClaimButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: splashOrange,
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: Text(
          tr('home.claim_now'),
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// ── Salon logo ────────────────────────────────────────────────────────────────

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
//
// Painted outside ClipPath so the shadow bleeds naturally:
//   1. Soft shadow following the ticket outline.
//   2. Dark body fill + subtle border.
//   3. Orange dashed perforation at the stub/body junction.
// (The stub gradient itself is rendered by the widget layer.)

class _TicketBgPainter extends CustomPainter {
  const _TicketBgPainter({
    required this.stubW,
    required this.notchR,
    required this.cornerR,
    required this.bodyColor,
    required this.borderColor,
  });

  final double stubW;
  final double notchR;
  final double cornerR;
  final Color bodyColor;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _ticketPath(
      width: size.width,
      height: size.height,
      stubW: stubW,
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
        Offset(stubW, y),
        Offset(stubW, math.min(y + dashH, maxY)),
        dashPaint,
      );
      y += dashH + gapH;
    }
  }

  @override
  bool shouldRepaint(_TicketBgPainter old) =>
      old.stubW != stubW ||
      old.notchR != notchR ||
      old.cornerR != cornerR ||
      old.bodyColor != bodyColor ||
      old.borderColor != borderColor;
}

// ── Clipper ───────────────────────────────────────────────────────────────────

class _TicketClipper extends CustomClipper<Path> {
  const _TicketClipper({
    required this.stubW,
    required this.notchR,
    required this.cornerR,
  });

  final double stubW;
  final double notchR;
  final double cornerR;

  @override
  Path getClip(Size size) => _ticketPath(
    width: size.width,
    height: size.height,
    stubW: stubW,
    notchR: notchR,
    cornerR: cornerR,
  );

  @override
  bool shouldReclip(_TicketClipper old) =>
      old.stubW != stubW || old.notchR != notchR || old.cornerR != cornerR;
}

// ── Shared path builder ───────────────────────────────────────────────────────
//
// Ticket outline with rounded corners and two notches cut into the TOP and
// BOTTOM edges at x = stubW (the perforation line):
//
//   ╭──────⌄──────────────────────────╮   ← top notch at stubW
//   │ ▓▓▓▓ ┊                          │
//   │ ▓ %▓ ┊  Haircut Service         │
//   │ ▓▓▓▓ ┊  ✂ salon  [Claim Now →]  │
//   ╰──────⌃──────────────────────────╯   ← bottom notch at stubW

Path _ticketPath({
  required double width,
  required double height,
  required double stubW,
  required double notchR,
  required double cornerR,
}) {
  final path = Path();
  final r = cornerR;
  final nr = notchR;

  // Top edge → with notch at stubW bowing DOWN into the card
  path.moveTo(r, 0);
  path.lineTo(stubW - nr, 0);
  path.arcToPoint(
    Offset(stubW + nr, 0),
    radius: Radius.circular(nr),
    clockwise: false,
  );
  path.lineTo(width - r, 0);
  path.arcToPoint(Offset(width, r), radius: Radius.circular(r));

  // Right edge ↓
  path.lineTo(width, height - r);
  path.arcToPoint(Offset(width - r, height), radius: Radius.circular(r));

  // Bottom edge ← with notch at stubW bowing UP into the card
  path.lineTo(stubW + nr, height);
  path.arcToPoint(
    Offset(stubW - nr, height),
    radius: Radius.circular(nr),
    clockwise: false,
  );
  path.lineTo(r, height);
  path.arcToPoint(Offset(0, height - r), radius: Radius.circular(r));

  // Left edge ↑
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
                    child: Container(
                      width: 310.w,
                      height: 120.h,
                      decoration: BoxDecoration(
                        color: colors.neutral200,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
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
