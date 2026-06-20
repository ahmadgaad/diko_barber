import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zain/core/router/app_routes.dart';
import 'package:zain/core/shared/domain/entities/nearest_service.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/core/widgets/app_gradient_button.dart';
import 'package:zain/core/widgets/auth_gate.dart';
import 'package:zain/features/booking_schedule/presentation/booking_schedule_args.dart';

class ServiceDetailSheet extends StatelessWidget {
  const ServiceDetailSheet({
    super.key,
    required this.service,
    required this.rootContext,
  });

  final NearestService service;
  final BuildContext rootContext;

  static void show(
    BuildContext context, {
    required NearestService service,
    required AppColors colors,
  }) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          ServiceDetailSheet(service: service, rootContext: context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.neutral50,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 12.h, bottom: 16.h),
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colors.neutral300,
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
            ),
          ),
          _HeaderCard(service: service, colors: colors),
          SizedBox(height: 20.h),
          Text(
            tr('home.salon'),
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: colors.neutral500,
            ),
          ),
          SizedBox(height: 8.h),
          _SalonRow(service: service, colors: colors, rootContext: rootContext),
          SizedBox(height: 20.h),
          Text(
            tr('home.details'),
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: colors.neutral500,
            ),
          ),
          SizedBox(height: 8.h),
          _DetailsCard(service: service, colors: colors),
          SizedBox(height: 28.h),
          AppGradientButton(
            label: tr('home.book_now'),
            onTap: () {
              Navigator.of(context).pop();
              AuthGate.guard(
                rootContext,
                () => rootContext.push(
                  AppRoutes.bookingSchedule,
                  extra: BookingScheduleArgs(
                    salonId: service.salon.id,
                    salonName: service.salon.name,
                    serviceIds: {service.id},
                    packageIds: const {},
                  ),
                ),
              );
            },
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 16.h),
        ],
      ),
    );
  }
}

// ── Header card ──────────────────────────────────────────────────────────────

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.service, required this.colors});
  final NearestService service;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: service.image,
            width: double.infinity,
            height: 180.h,
            fit: BoxFit.cover,
            placeholder: (_, _) =>
                Container(height: 180.h, color: colors.neutral200),
            errorWidget: (_, _, _) => Container(
              height: 180.h,
              color: colors.neutral200,
              alignment: Alignment.center,
              child: Icon(
                Icons.content_cut_rounded,
                color: colors.neutral400,
                size: 40.r,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(16.w, 32.h, 16.w, 14.h),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xCC000000)],
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          service.name,
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        if (service.categoryName != null) ...[
                          SizedBox(height: 4.h),
                          Text(
                            service.categoryName!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
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
                          service.effectivePrice.toStringAsFixed(0),
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.0,
                          ),
                        ),
                        Text(
                          tr('home.currency'),
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (service.hasDiscount)
            PositionedDirectional(
              top: 10.h,
              start: 10.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  _discountLabel,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String get _discountLabel {
    final d = service.discount;
    if (d == null) return '';
    if (d.type == 'percentage') return '-${d.value.toStringAsFixed(0)}%';
    return '-${d.value.toStringAsFixed(0)}';
  }
}

// ── Salon row ────────────────────────────────────────────────────────────────

class _SalonRow extends StatelessWidget {
  const _SalonRow({
    required this.service,
    required this.colors,
    required this.rootContext,
  });
  final NearestService service;
  final AppColors colors;
  final BuildContext rootContext;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.neutral100,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          rootContext.push('/salon/${service.salon.id}');
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
                  imageUrl: service.salon.image,
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
                      service.salon.name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.neutral900,
                      ),
                    ),
                    if (service.salon.location != null ||
                        service.salon.distance != null) ...[
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          if (service.salon.location != null) ...[
                            Icon(
                              Icons.location_on_outlined,
                              size: 12.r,
                              color: colors.neutral400,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                service.salon.location!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: colors.neutral500,
                                ),
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
    );
  }
}

// ── Details card ─────────────────────────────────────────────────────────────

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.service, required this.colors});
  final NearestService service;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: Column(
        children: [
          _DetailRow(
            icon: Icons.timer_outlined,
            label: tr('service_details.duration'),
            value: '${service.durationMinutes} ${tr('home.min')}',
            colors: colors,
            isFirst: true,
          ),
          if (service.categoryName != null)
            _DetailRow(
              icon: Icons.category_outlined,
              label: tr('service_details.category'),
              value: service.categoryName!,
              colors: colors,
            ),
          _DetailRow(
            icon: Icons.attach_money_rounded,
            label: tr('service_details.price'),
            value: '${service.price.toStringAsFixed(0)} ${tr('home.currency')}',
            colors: colors,
          ),
          if (service.hasDiscount)
            _DetailRow(
              icon: Icons.local_offer_outlined,
              label: tr('service_details.discounted_price'),
              value:
                  '${service.effectivePrice.toStringAsFixed(0)} ${tr('home.currency')}',
              colors: colors,
              valueColor: splashOrange,
            ),
          if (service.distance != null)
            _DetailRow(
              icon: Icons.location_on_outlined,
              label: tr('service_details.distance'),
              value: service.distance!.formatted,
              colors: colors,
              isLast: true,
            ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.colors,
    this.isFirst = false,
    this.isLast = false,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final AppColors colors;
  final bool isFirst;
  final bool isLast;
  final Color? valueColor;

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
                  color: valueColor ?? colors.neutral900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
