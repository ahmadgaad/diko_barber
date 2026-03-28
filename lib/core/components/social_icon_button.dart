import 'package:diko_barber/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialIconButton extends StatelessWidget {
  const SocialIconButton({
    super.key,
    required this.svgPath,
    required this.onTap,
    this.colorFilter,
  });

  final String svgPath;
  final VoidCallback onTap;
  final ColorFilter? colorFilter;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48.w,
        height: 48.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark ? neutral600 : neutral300,
          ),
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          svgPath,
          width: 24.w,
          height: 24.h,
          colorFilter: colorFilter,
        ),
      ),
    );
  }
}
