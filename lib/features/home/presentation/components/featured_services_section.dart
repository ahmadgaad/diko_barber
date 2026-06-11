import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/shared/domain/entities/featured_service.dart';
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
  final List<FeaturedService> services;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SectionHeader(titleKey: 'home.featured_services', colors: colors),
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
                child: _ServiceCard(service: service),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service});
  final FeaturedService service;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SizedBox(
      width: 140.w,
      height: 180.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            CachedNetworkImage(
              imageUrl: service.image,
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(color: colors.neutral200),
              errorWidget: (_, _, _) => Container(
                color: colors.neutral200,
                child: Icon(Icons.content_cut_outlined,
                    color: colors.neutral400, size: 36.r),
              ),
            ),
            // Dark gradient overlay
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.3, 1.0],
                  colors: [Colors.transparent, Color(0xE6000000)],
                ),
              ),
            ),
            // Content at bottom
            Positioned(
              left: 10.w,
              right: 10.w,
              bottom: 10.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star_rounded,
                          color: const Color(0xFFFFC107), size: 12.r),
                      SizedBox(width: 2.w),
                      Text(
                        service.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    service.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: splashOrange,
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Text(
                          '${service.price.toStringAsFixed(0)} ${tr('home.currency')}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        service.isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: service.isFavorite ? splashOrange : Colors.white,
                        size: 18.r,
                      ),
                    ],
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

// ── Shimmer ───────────────────────────────────────────────────────────────────

class _ServicesShimmer extends StatelessWidget {
  const _ServicesShimmer({required this.colors});
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
                children: List.generate(4, (i) {
                  return Padding(
                    padding: EdgeInsetsDirectional.only(end: 12.w),
                    child: Container(
                      width: 140.w,
                      height: 180.h,
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
