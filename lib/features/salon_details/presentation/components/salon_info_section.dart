import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/features/salon_details/domain/entities/salon_details.dart';

class SalonInfoSection extends StatelessWidget {
  const SalonInfoSection({super.key, required this.salon, required this.colors});

  final SalonDetails salon;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.neutral50,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + rating row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  salon.name,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.neutral900,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              _RatingBadge(rating: salon.rating, colors: colors),
            ],
          ),
          SizedBox(height: 6.h),
          // Review count + distance + open status
          Row(
            children: [
              Icon(
                Icons.reviews_outlined,
                size: 14.r,
                color: colors.neutral500,
              ),
              SizedBox(width: 4.w),
              Text(
                '${salon.reviewCount} ${tr('salon_details.reviews')}',
                style: TextStyle(fontSize: 12.sp, color: colors.neutral500),
              ),
              SizedBox(width: 10.w),
              _Dot(colors: colors),
              SizedBox(width: 10.w),
              Icon(
                Icons.location_on_outlined,
                size: 14.r,
                color: colors.neutral500,
              ),
              SizedBox(width: 4.w),
              Text(
                '${salon.distance.toStringAsFixed(1)} ${tr('home.km')}',
                style: TextStyle(fontSize: 12.sp, color: colors.neutral500),
              ),
              SizedBox(width: 10.w),
              _Dot(colors: colors),
              SizedBox(width: 10.w),
              Text(
                tr(salon.isOpen ? 'home.open' : 'home.closed'),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: salon.isOpen ? colors.success500 : colors.error500,
                ),
              ),
              if (salon.isOpen && salon.closingTime != null) ...[
                Text(
                  ' · ${salon.closingTime}',
                  style: TextStyle(fontSize: 12.sp, color: colors.neutral500),
                ),
              ],
            ],
          ),
          SizedBox(height: 8.h),
          // Address
          Row(
            children: [
              Icon(Icons.map_outlined, size: 14.r, color: colors.neutral400),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  salon.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, color: colors.neutral500),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          // Categories
          if (salon.categories.isNotEmpty)
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: salon.categories.map((cat) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary50,
                    borderRadius: BorderRadius.circular(999.r),
                    border: Border.all(color: colors.primary200),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.primary500,
                    ),
                  ),
                );
              }).toList(),
            ),
          SizedBox(height: 10.h),
          // Description
          Text(
            salon.description,
            style: TextStyle(
              fontSize: 13.sp,
              height: 1.6,
              color: colors.neutral600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating, required this.colors});

  final double rating;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E7),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: const Color(0xFFFFC107).withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, color: const Color(0xFFFFC107), size: 14.r),
          SizedBox(width: 3.w),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF6B4F00),
            ),
          ),
        ],
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
      height: 3.w,
      decoration: BoxDecoration(
        color: colors.neutral400,
        shape: BoxShape.circle,
      ),
    );
  }
}
