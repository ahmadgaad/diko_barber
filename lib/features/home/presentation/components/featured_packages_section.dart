import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/shared/domain/entities/package.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/features/home/presentation/components/section_header.dart';
import 'package:ronaq_barber/features/home/presentation/cubit/featured_packages_cubit.dart';
import 'package:ronaq_barber/features/home/presentation/cubit/featured_packages_state.dart';
import 'package:shimmer/shimmer.dart';

class FeaturedPackagesSection extends StatelessWidget {
  const FeaturedPackagesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocBuilder<FeaturedPackagesCubit, FeaturedPackagesState>(
      builder: (context, state) => switch (state) {
        FeaturedPackagesLoading() => _PackagesShimmer(colors: colors),
        FeaturedPackagesLoaded(:final packages) when packages.isEmpty =>
          const SizedBox.shrink(),
        FeaturedPackagesLoaded(:final packages) =>
          _PackagesList(packages: packages, colors: colors),
        FeaturedPackagesError() => const SizedBox.shrink(),
      },
    );
  }
}

// ── Loaded list ───────────────────────────────────────────────────────────────

class _PackagesList extends StatelessWidget {
  const _PackagesList({required this.packages, required this.colors});
  final List<Package> packages;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SectionHeader(titleKey: 'home.featured_packages', colors: colors),
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: packages.map((pkg) {
              return Padding(
                padding: EdgeInsetsDirectional.only(end: 12.w),
                child: _PackageCard(package: pkg),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.package});
  final Package package;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SizedBox(
      width: 160.w,
      height: 200.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            CachedNetworkImage(
              imageUrl: package.image,
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(color: colors.neutral200),
              errorWidget: (_, _, _) => Container(
                color: colors.neutral200,
                child: Icon(Icons.spa_outlined,
                    color: colors.neutral400, size: 40.r),
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
              left: 12.w,
              right: 12.w,
              bottom: 12.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    package.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: splashOrange,
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Text(
                          '${package.price.toStringAsFixed(0)} ${tr('home.currency')}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        package.isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: package.isFavorite
                            ? splashOrange
                            : Colors.white,
                        size: 20.r,
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

class _PackagesShimmer extends StatelessWidget {
  const _PackagesShimmer({required this.colors});
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
                  width: 140.w,
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
                children: List.generate(3, (i) {
                  return Padding(
                    padding: EdgeInsetsDirectional.only(end: 12.w),
                    child: Container(
                      width: 160.w,
                      height: 200.h,
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
