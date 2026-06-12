import 'package:ronaq_barber/core/resources/svg_resources.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.titleKey,
    required this.colors,
    this.onSeeMore,
  });

  final String titleKey;
  final AppColors colors;
  final VoidCallback? onSeeMore;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 3.w,
          height: 18.h,
          decoration: BoxDecoration(
            color: splashOrange,
            borderRadius: BorderRadius.circular(999.r),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            tr(titleKey),
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: colors.neutral900,
            ),
          ),
        ),
        GestureDetector(
          onTap: onSeeMore,
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tr('home.see_more'),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: splashOrange,
                ),
              ),
              SizedBox(width: 2.w),
              Transform.scale(
                scaleX: isRtl ? -1 : 1,
                child: SvgPicture.asset(
                  SvgResources.chevronRight,
                  width: 14.r,
                  height: 14.r,
                  colorFilter:
                      ColorFilter.mode(splashOrange, BlendMode.srcIn),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
