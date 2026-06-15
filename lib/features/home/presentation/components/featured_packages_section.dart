import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zain/core/shared/domain/entities/nearest_package.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/core/widgets/auth_gate.dart';
import 'package:zain/features/home/presentation/components/section_header.dart';
import 'package:zain/features/home/presentation/cubit/featured_packages_cubit.dart';
import 'package:zain/features/home/presentation/cubit/featured_packages_state.dart';
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
  final List<NearestPackage> packages;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SectionHeader(
            titleKey: 'home.featured_packages',
            colors: colors,
            onSeeMore: () => context.push('/packages'),
          ),
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
                child: GestureDetector(
                  onTap: () => context.push('/package/${pkg.id}'),
                  child: _PackageCard(package: pkg),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 14.h),
      ],
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.package});
  final NearestPackage package;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
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
          _PackageImage(package: package, colors: colors),
          Padding(
            padding: EdgeInsets.all(12.r),
            child: _PackageInfo(package: package, colors: colors),
          ),
        ],
      ),
    );
  }
}

class _PackageImage extends StatelessWidget {
  const _PackageImage({required this.package, required this.colors});
  final NearestPackage package;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: package.image,
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
            child: Icon(Icons.spa_outlined, color: colors.neutral400, size: 36.r),
          ),
        ),
        if (package.hasDiscount)
          PositionedDirectional(
            top: 10.h,
            start: 10.w,
            child: _DiscountBadge(package: package),
          ),
        PositionedDirectional(
          top: 10.h,
          end: 10.w,
          child: GestureDetector(
            onTap: () => AuthGate.guard(
              context,
              () => context
                  .read<FeaturedPackagesCubit>()
                  .toggleFavorite(package.id),
            ),
            child: Container(
              width: 28.r,
              height: 28.r,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                shape: BoxShape.circle,
              ),
              child: Icon(
                package.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: package.isFavorite ? Colors.red : Colors.white,
                size: 15.r,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  const _DiscountBadge({required this.package});
  final NearestPackage package;

  String get _label {
    final d = package.discount;
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

class _PackageInfo extends StatelessWidget {
  const _PackageInfo({required this.package, required this.colors});
  final NearestPackage package;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title + duration in one row
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                package.name,
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
                  '${package.durationMinutes} ${tr('home.min')}',
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
            Icon(Icons.storefront_outlined, size: 12.r, color: colors.neutral500),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                package.salon.name,
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
              '${package.effectivePrice.toStringAsFixed(0)} ${tr('home.currency')}',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: splashOrange,
              ),
            ),
            if (package.hasDiscount) ...[
              SizedBox(width: 6.w),
              Text(
                '${package.price.toStringAsFixed(0)} ${tr('home.currency')}',
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

class _PackageCardShimmer extends StatelessWidget {
  const _PackageCardShimmer({required this.colors});
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
          // Image placeholder
          Container(width: 200.w, height: 130.h, color: colors.neutral200),
          // Info area
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

class _PackagesShimmer extends StatelessWidget {
  const _PackagesShimmer({required this.colors});
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
                  child: _PackageCardShimmer(colors: colors),
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
