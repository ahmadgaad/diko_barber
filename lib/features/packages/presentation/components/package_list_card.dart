import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/shared/domain/entities/nearest_package.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/features/packages/presentation/components/package_discount_badge.dart';
import 'package:zain/features/packages/presentation/components/package_fav_button.dart';

class PackageListCard extends StatelessWidget {
  const PackageListCard({
    super.key,
    required this.package,
    required this.colors,
  });

  final NearestPackage package;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108.h,
      decoration: BoxDecoration(
        color: colors.neutral50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.neutral200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: package.image,
                width: 108.h,
                height: 108.h,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                  width: 108.h,
                  height: 108.h,
                  color: colors.neutral200,
                ),
                errorWidget: (_, _, _) => Container(
                  width: 108.h,
                  height: 108.h,
                  color: colors.neutral200,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.spa_outlined,
                    color: colors.neutral400,
                    size: 28.r,
                  ),
                ),
              ),
              if (package.hasDiscount)
                PositionedDirectional(
                  top: 6.h,
                  start: 6.w,
                  child: PackageDiscountBadge(package: package),
                ),
            ],
          ),
        Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          package.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: colors.neutral900,
                          ),
                        ),
                      ),
                      PackageFavButton(
                        package: package,
                        size: 28.r,
                        iconSize: 14.r,
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
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
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: colors.neutral500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 11.r,
                        color: colors.neutral500,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '${package.durationMinutes} ${tr('home.min')}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: colors.neutral500,
                        ),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${package.effectivePrice.toStringAsFixed(0)} ${tr('home.currency')}',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w800,
                              color: splashOrange,
                            ),
                          ),
                          if (package.hasDiscount)
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
