import 'package:diko_barber/core/resources/svg_resources.dart';
import 'package:diko_barber/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr('home.greeting', namedArgs: {'name': userName}),
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.neutral900,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  tr('home.greeting_subtitle'),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: colors.neutral700,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _IconButton(asset: SvgResources.search, colors: colors),
              SizedBox(width: 16.w),
              _IconButton(asset: SvgResources.notification, colors: colors),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.asset, required this.colors});

  final String asset;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24.w,
      height: 24.w,
      child: SvgPicture.asset(
        asset,
        fit: BoxFit.scaleDown,
        colorFilter: ColorFilter.mode(colors.neutral900, BlendMode.srcIn),
      ),
    );
  }
}
