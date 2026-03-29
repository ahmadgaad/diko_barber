import 'package:diko_barber/core/resources/image_resources.dart';
import 'package:diko_barber/core/resources/svg_resources.dart';
import 'package:diko_barber/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  static const _services = [
    (label: 'home.service_haircut', image: ImageResources.serviceHaircut),
    (label: 'home.service_beard_trim', image: ImageResources.serviceBeardTrim),
    (
      label: 'home.service_haircut_beard',
      image: ImageResources.serviceHaircutBeard,
    ),
    (
      label: 'home.service_face_cleanse',
      image: ImageResources.serviceFaceCleanse,
    ),
    (
      label: 'home.service_hair_styling',
      image: ImageResources.serviceHairStyling,
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
          _SectionHeader(titleKey: 'home.services', colors: colors),
          SizedBox(height: 12.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _services.map((service) {
                return Padding(
                  padding: EdgeInsetsDirectional.only(end: 12.w),
                  child: _ServiceItem(
                    labelKey: service.label,
                    imagePath: service.image,
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

class _ServiceItem extends StatelessWidget {
  const _ServiceItem({
    required this.labelKey,
    required this.imagePath,
    required this.colors,
  });

  final String labelKey;
  final String imagePath;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 74.w,
      child: Column(
        children: [
          ClipOval(
            child: Image.asset(
              imagePath,
              width: 74.w,
              height: 74.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            tr(labelKey),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: colors.neutral900,
            ),
          ),
        ],
      ),
    );
  }
}

class PackagesSection extends StatelessWidget {
  const PackagesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: _SectionHeader(titleKey: 'home.packages', colors: colors),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.titleKey, required this.colors});

  final String titleKey;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          tr(titleKey),
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: colors.neutral900,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tr('home.see_more'),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: colors.neutral900,
              ),
            ),
            SizedBox(width: 6.w),
            Transform.scale(
              scaleX: isRtl ? -1 : 1,
              child: SvgPicture.asset(
                SvgResources.chevronRight,
                width: 20.w,
                height: 20.w,
                colorFilter: ColorFilter.mode(
                  colors.neutral900,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
