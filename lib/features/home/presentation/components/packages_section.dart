import 'package:diko_barber/core/resources/image_resources.dart';
import 'package:diko_barber/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'section_header.dart';

class PackagesSection extends StatelessWidget {
  const PackagesSection({super.key});

  static const _packages = [
    (
      titleKey: 'home.package_basic_groom',
      descKey: 'home.package_basic_groom_desc',
      image: ImageResources.packageBasicGroom,
      price: '200',
    ),
    (
      titleKey: 'home.package_full_groom',
      descKey: 'home.package_full_groom_desc',
      image: ImageResources.packageFullGroom,
      price: '300',
    ),
    (
      titleKey: 'home.package_vip',
      descKey: 'home.package_vip_desc',
      image: ImageResources.packageVip,
      price: '500',
    ),
    (
      titleKey: 'home.package_wedding',
      descKey: 'home.package_wedding_desc',
      image: ImageResources.packageWedding,
      price: '1000',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(titleKey: 'home.packages', colors: colors),
          SizedBox(height: 16.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _packages.map((pkg) {
                return Padding(
                  padding: EdgeInsetsDirectional.only(end: 12.w),
                  child: _PackageCard(
                    titleKey: pkg.titleKey,
                    descKey: pkg.descKey,
                    imagePath: pkg.image,
                    price: pkg.price,
                    colors: colors,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({
    required this.titleKey,
    required this.descKey,
    required this.imagePath,
    required this.price,
    required this.colors,
  });

  final String titleKey;
  final String descKey;
  final String imagePath;
  final String price;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 216.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              imagePath,
              width: 216.w,
              height: 144.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            tr(titleKey),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: colors.neutral900,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            tr(descKey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: colors.neutral700,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Text(
                price,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: colors.primary500,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                tr('home.currency'),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: colors.neutral900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
