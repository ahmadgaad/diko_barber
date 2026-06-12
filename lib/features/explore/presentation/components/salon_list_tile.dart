import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/shared/domain/entities/salon.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';

class SalonListTile extends StatelessWidget {
  const SalonListTile({super.key, required this.salon, this.onTap});

  final Salon salon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: colors.neutral100,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: colors.neutral200),
        ),
        child: Row(
          children: [
            _SalonImage(salon: salon, colors: colors),
            SizedBox(width: 12.w),
            Expanded(
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
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.neutral900,
                          ),
                        ),
                      ),
                      Icon(
                        salon.isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: salon.isFavorite
                            ? splashOrange
                            : colors.neutral400,
                        size: 20.r,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: const Color(0xFFFFC107),
                        size: 14.r,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        salon.averageRating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: colors.neutral700,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      _Dot(colors: colors),
                      SizedBox(width: 6.w),
                      Text(
                        salon.distance?.formatted ?? '-',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: colors.neutral700,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      _Dot(colors: colors),
                      SizedBox(width: 6.w),
                      Text(
                        tr(salon.isOpen ? 'home.open' : 'home.closed'),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: salon.isOpen
                              ? colors.success500
                              : colors.error500,
                        ),
                      ),
                    ],
                  ),
                  if (salon.categories.isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    _CategoryChips(
                      categories: salon.categories,
                      colors: colors,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SalonImage extends StatelessWidget {
  const _SalonImage({required this.salon, required this.colors});
  final Salon salon;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: CachedNetworkImage(
        imageUrl: salon.image,
        width: 84.r,
        height: 84.r,
        fit: BoxFit.cover,
        placeholder: (_, _) =>
            Container(width: 84.r, height: 84.r, color: colors.neutral200),
        errorWidget: (_, _, _) => Container(
          width: 84.r,
          height: 84.r,
          color: colors.neutral200,
          alignment: Alignment.center,
          child: Icon(
            Icons.store_outlined,
            color: colors.neutral400,
            size: 30.r,
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3.w,
      height: 3.h,
      decoration: BoxDecoration(
        color: colors.neutral400,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({required this.categories, required this.colors});
  final List<String> categories;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final visible = categories.take(3).toList();
    return Wrap(
      spacing: 4.w,
      children: visible.map((cat) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: colors.neutral50,
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(color: colors.neutral200),
          ),
          child: Text(
            cat,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: colors.neutral700,
            ),
          ),
        );
      }).toList(),
    );
  }
}
