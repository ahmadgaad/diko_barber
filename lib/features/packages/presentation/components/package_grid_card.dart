import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/shared/domain/entities/nearest_package.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/features/packages/presentation/components/package_discount_badge.dart';
import 'package:zain/features/packages/presentation/components/package_fav_button.dart';

class PackageGridCard extends StatelessWidget {
  const PackageGridCard({
    super.key,
    required this.package,
    required this.colors,
  });

  final NearestPackage package;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.neutral50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.neutral200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GridImage(package: package, colors: colors),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.r),
              child: _GridInfo(package: package, colors: colors),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridImage extends StatelessWidget {
  const _GridImage({required this.package, required this.colors});

  final NearestPackage package;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: package.image,
          width: double.infinity,
          height: 130.h,
          fit: BoxFit.cover,
          placeholder: (_, _) => Container(
            width: double.infinity,
            height: 130.h,
            color: colors.neutral200,
          ),
          errorWidget: (_, _, _) => Container(
            width: double.infinity,
            height: 130.h,
            color: colors.neutral200,
            alignment: Alignment.center,
            child: Icon(
              Icons.spa_outlined,
              color: colors.neutral400,
              size: 32.r,
            ),
          ),
        ),
        if (package.hasDiscount)
          PositionedDirectional(
            top: 8.h,
            start: 8.w,
            child: PackageDiscountBadge(package: package),
          ),
        PositionedDirectional(
          top: 8.h,
          end: 8.w,
          child: PackageFavButton(
            package: package,
            size: 26.r,
            iconSize: 14.r,
          ),
        ),
      ],
    );
  }
}

class _GridInfo extends StatelessWidget {
  const _GridInfo({required this.package, required this.colors});

  final NearestPackage package;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                package.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.neutral900,
                  height: 1.3,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 10.r,
                  color: colors.neutral500,
                ),
                SizedBox(width: 2.w),
                Text(
                  '${package.durationMinutes} ${tr('home.min')}',
                  style: TextStyle(fontSize: 10.sp, color: colors.neutral500),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Icon(
              Icons.storefront_outlined,
              size: 11.r,
              color: colors.neutral500,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                package.salon.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10.sp, color: colors.neutral500),
              ),
            ),
          ],
        ),
        const Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${package.effectivePrice.toStringAsFixed(0)} ${tr('home.currency')}',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: splashOrange,
              ),
            ),
            if (package.hasDiscount) ...[
              SizedBox(width: 4.w),
              Text(
                package.price.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 10.sp,
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
