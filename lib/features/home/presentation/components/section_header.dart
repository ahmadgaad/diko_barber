import 'package:diko_barber/core/resources/svg_resources.dart';
import 'package:diko_barber/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.titleKey, required this.colors});

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
