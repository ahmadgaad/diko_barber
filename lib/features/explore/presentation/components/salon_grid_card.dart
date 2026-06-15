import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/shared/domain/entities/salon.dart';
import 'package:zain/core/theme/app_colors.dart';

class SalonGridCard extends StatelessWidget {
  const SalonGridCard({
    super.key,
    required this.salon,
    required this.isHighlighted,
    this.onTap,
    this.onFavoriteTap,
  });

  final Salon salon;
  final bool isHighlighted;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: colors.neutral100,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isHighlighted ? splashOrange : colors.neutral200,
            width: isHighlighted ? 2 : 1,
          ),
          boxShadow: isHighlighted
              ? [
                  BoxShadow(
                    color: splashOrange.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CoverImage(salon: salon, colors: colors),
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          salon.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.neutral900,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onFavoriteTap,
                        behavior: HitTestBehavior.opaque,
                        child: Icon(
                          salon.isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: salon.isFavorite
                              ? splashOrange
                              : colors.neutral400,
                          size: 16.r,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: const Color(0xFFFFC107),
                        size: 12.r,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        salon.averageRating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: colors.neutral700,
                        ),
                      ),
                      if (salon.distance != null) ...[
                        SizedBox(width: 4.w),
                        Text(
                          '·',
                          style: TextStyle(
                            color: colors.neutral400,
                            fontSize: 11.sp,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          salon.distance!.formatted,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: colors.neutral600,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 6.h),
                  _OpenStatusPill(salon: salon, colors: colors),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage({required this.salon, required this.colors});
  final Salon salon;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
      child: CachedNetworkImage(
        imageUrl: salon.image,
        width: double.infinity,
        height: 100.h,
        fit: BoxFit.cover,
        placeholder: (_, _) =>
            Container(height: 100.h, color: colors.neutral200),
        errorWidget: (_, _, _) => Container(
          height: 100.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                splashOrange.withValues(alpha: 0.18),
                splashOrange.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: Icon(
            Icons.storefront_rounded,
            color: splashOrange.withValues(alpha: 0.55),
            size: 32.r,
          ),
        ),
      ),
    );
  }
}

class _OpenStatusPill extends StatelessWidget {
  const _OpenStatusPill({required this.salon, required this.colors});
  final Salon salon;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: salon.isOpen ? colors.success50 : colors.error50,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        tr(salon.isOpen ? 'home.open' : 'home.closed'),
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: salon.isOpen ? colors.success600 : colors.error600,
        ),
      ),
    );
  }
}
