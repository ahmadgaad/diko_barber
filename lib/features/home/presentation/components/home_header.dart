import 'dart:ui';

import 'package:zain/core/resources/svg_resources.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.userName,
    this.location,
    this.onSearchTap,
  });

  final String userName;
  final String? location;
  final VoidCallback? onSearchTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (location != null) ...[
                  Row(
                    children: [
                      SvgPicture.asset(
                        SvgResources.locationPin,
                        width: 14.r,
                        height: 14.r,
                        colorFilter:
                            ColorFilter.mode(splashOrange, BlendMode.srcIn),
                      ),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: Text(
                          location!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: colors.neutral500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                ],
                Text(
                  tr('home.greeting', namedArgs: {'name': userName}),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.neutral900,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  tr('home.greeting_subtitle'),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: colors.neutral500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          _HeaderIconButton(
            asset: SvgResources.search,
            colors: colors,
            onTap: onSearchTap,
          ),
          SizedBox(width: 10.w),
          _HeaderIconButton(
            asset: SvgResources.notification,
            colors: colors,
            hasBadge: true,
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.asset,
    required this.colors,
    this.onTap,
    this.hasBadge = false,
  });

  final String asset;
  final AppColors colors;
  final VoidCallback? onTap;
  final bool hasBadge;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glassColor = isDark
        ? const Color(0xFF1A1A1A).withValues(alpha: 0.60)
        : Colors.white.withValues(alpha: 0.65);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : Colors.white.withValues(alpha: 0.70);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          RepaintBoundary(
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: BoxDecoration(
                    color: glassColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      asset,
                      width: 20.r,
                      height: 20.r,
                      colorFilter: ColorFilter.mode(
                        colors.neutral700,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (hasBadge)
            PositionedDirectional(
              top: 1.r,
              end: 1.r,
              child: Container(
                width: 9.r,
                height: 9.r,
                decoration: BoxDecoration(
                  color: splashOrange,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.neutral50, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
