import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/features/salon_details/domain/entities/salon_staff.dart';
import 'package:zain/features/salon_details/presentation/components/empty_tab.dart';

class StaffTab extends StatelessWidget {
  const StaffTab({super.key, required this.staff, required this.colors});

  final List<SalonStaff> staff;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    if (staff.isEmpty) {
      return EmptyTab(
        icon: Icons.people_outline_rounded,
        message: tr('salon_details.no_staff'),
        colors: colors,
      );
    }
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      physics: const BouncingScrollPhysics(),
      itemCount: staff.length,
      separatorBuilder: (_, _) => SizedBox(height: 10.h),
      itemBuilder: (context, i) => _StaffCard(member: staff[i], colors: colors),
    );
  }
}

class _StaffCard extends StatelessWidget {
  const _StaffCard({required this.member, required this.colors});

  final SalonStaff member;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: Row(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: member.image,
              width: 48.r,
              height: 48.r,
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(
                width: 48.r,
                height: 48.r,
                color: colors.neutral200,
              ),
              errorWidget: (_, _, _) => Container(
                width: 48.r,
                height: 48.r,
                color: colors.neutral200,
                alignment: Alignment.center,
                child: Icon(
                  Icons.person_outline,
                  color: colors.neutral400,
                  size: 24.r,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              member.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: colors.neutral900,
              ),
            ),
          ),
          Icon(Icons.star_rounded, size: 15.r, color: const Color(0xFFFFC107)),
          SizedBox(width: 3.w),
          Text(
            member.rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: colors.neutral700,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            '(${member.ratingsCount})',
            style: TextStyle(fontSize: 11.sp, color: colors.neutral400),
          ),
        ],
      ),
    );
  }
}
