import 'package:ronaq_barber/core/resources/image_resources.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/features/home/presentation/components/section_header.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          SectionHeader(titleKey: 'home.services', colors: colors),
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
