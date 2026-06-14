import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';

class ExploreBackButton extends StatelessWidget {
  const ExploreBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return PositionedDirectional(
      top: MediaQuery.paddingOf(context).top + 8.h,
      start: 16.w,
      child: Material(
        color: colors.neutral50,
        shape: const CircleBorder(),
        elevation: 4,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => context.pop(),
          child: Padding(
            padding: EdgeInsets.all(10.r),
            child: Icon(
              Icons.arrow_back_rounded,
              size: 22.r,
              color: colors.neutral900,
            ),
          ),
        ),
      ),
    );
  }
}
