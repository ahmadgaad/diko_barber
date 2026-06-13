import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/shared/domain/entities/nearest_service.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/features/home/presentation/components/section_header.dart';
import 'package:ronaq_barber/features/home/presentation/cubit/featured_services_cubit.dart';
import 'package:ronaq_barber/features/home/presentation/cubit/featured_services_state.dart';
import 'package:shimmer/shimmer.dart';

class FeaturedServicesSection extends StatelessWidget {
  const FeaturedServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocBuilder<FeaturedServicesCubit, FeaturedServicesState>(
      builder: (context, state) => switch (state) {
        FeaturedServicesLoading() => _ServicesShimmer(colors: colors),
        FeaturedServicesLoaded(:final services) when services.isEmpty =>
          const SizedBox.shrink(),
        FeaturedServicesLoaded(:final services) =>
          _ServicesList(services: services, colors: colors),
        FeaturedServicesError() => const SizedBox.shrink(),
      },
    );
  }
}

// ── Loaded list ───────────────────────────────────────────────────────────────

class _ServicesList extends StatelessWidget {
  const _ServicesList({required this.services, required this.colors});
  final List<NearestService> services;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child:
              SectionHeader(titleKey: 'home.featured_services', colors: colors),
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: services.map((service) {
              return Padding(
                padding: EdgeInsetsDirectional.only(end: 12.w),
                child: _ServiceCard(service: service, colors: colors),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ── Card ──────────────────────────────────────────────────────────────────────

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service, required this.colors});
  final NearestService service;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      decoration: BoxDecoration(
        color: colors.neutral50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.neutral200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ServiceImage(service: service, colors: colors),
          Padding(
            padding: EdgeInsets.all(12.r),
            child: _ServiceInfo(service: service, colors: colors),
          ),
        ],
      ),
    );
  }
}

class _ServiceImage extends StatelessWidget {
  const _ServiceImage({required this.service, required this.colors});
  final NearestService service;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: service.image,
          width: 200.w,
          height: 130.h,
          fit: BoxFit.cover,
          placeholder: (_, _) =>
              Container(width: 200.w, height: 130.h, color: colors.neutral200),
          errorWidget: (_, _, _) => Container(
            width: 200.w,
            height: 130.h,
            color: colors.neutral200,
            alignment: Alignment.center,
            child: Icon(Icons.content_cut_outlined,
                color: colors.neutral400, size: 36.r),
          ),
        ),
        if (service.hasDiscount)
          PositionedDirectional(
            top: 10.h,
            start: 10.w,
            child: _DiscountBadge(service: service),
          ),
        PositionedDirectional(
          top: 10.h,
          end: 10.w,
          child: Container(
            width: 28.r,
            height: 28.r,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_border_rounded,
              color: Colors.white,
              size: 15.r,
            ),
          ),
        ),
      ],
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  const _DiscountBadge({required this.service});
  final NearestService service;

  String get _label {
    final d = service.discount;
    if (d == null) return '';
    if (d.type == 'percentage') return '-${d.value.toStringAsFixed(0)}%';
    return '-${d.value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE53935),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        _label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _ServiceInfo extends StatelessWidget {
  const _ServiceInfo({required this.service, required this.colors});
  final NearestService service;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Name + duration in one row
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                service.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.neutral900,
                  height: 1.3,
                ),
              ),
            ),
            SizedBox(width: 6.w),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.access_time_rounded,
                    size: 12.r, color: colors.neutral500),
                SizedBox(width: 3.w),
                Text(
                  '${service.durationMinutes} ${tr('home.min')}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: colors.neutral500,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 4.h),
        // Salon name
        Row(
          children: [
            Icon(Icons.storefront_outlined,
                size: 12.r, color: colors.neutral500),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                service.salon.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: colors.neutral500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        // Prices in one row
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${service.effectivePrice.toStringAsFixed(0)} ${tr('home.currency')}',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: splashOrange,
              ),
            ),
            if (service.hasDiscount) ...[
              SizedBox(width: 6.w),
              Text(
                '${service.price.toStringAsFixed(0)} ${tr('home.currency')}',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: colors.neutral400,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: colors.neutral400,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

// ── Shimmer ───────────────────────────────────────────────────────────────────

class _ServiceCardShimmer extends StatelessWidget {
  const _ServiceCardShimmer({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      decoration: BoxDecoration(
        color: colors.neutral50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.neutral200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 200.w, height: 130.h, color: colors.neutral200),
          Padding(
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 140.w,
                  height: 13.h,
                  decoration: BoxDecoration(
                    color: colors.neutral200,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  width: 90.w,
                  height: 11.h,
                  decoration: BoxDecoration(
                    color: colors.neutral200,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 55.w,
                      height: 11.h,
                      decoration: BoxDecoration(
                        color: colors.neutral200,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    Container(
                      width: 50.w,
                      height: 13.h,
                      decoration: BoxDecoration(
                        color: colors.neutral200,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServicesShimmer extends StatelessWidget {
  const _ServicesShimmer({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Shimmer.fromColors(
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
        ),
        SizedBox(height: 12.h),
        Shimmer.fromColors(
          baseColor: colors.neutral200,
          highlightColor: colors.neutral100,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: List.generate(
                3,
                (_) => Padding(
                  padding: EdgeInsetsDirectional.only(end: 12.w),
                  child: _ServiceCardShimmer(colors: colors),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 14.h),
      ],
    );
  }
}
