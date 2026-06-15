import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zain/core/router/app_routes.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/core/widgets/app_gradient_button.dart';

class SalonRegisterSuccessScreen extends StatelessWidget {
  const SalonRegisterSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              _buildSuccessIcon(colors),
              SizedBox(height: 40.h),
              Text(
                tr('salon_auth.success_title'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.neutral900,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                tr('salon_auth.success_subtitle'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                  color: colors.neutral600,
                  height: 1.7,
                ),
              ),
              SizedBox(height: 24.h),
              _buildInfoCard(colors),
              const Spacer(),
              AppGradientButton(
                label: tr('salon_auth.go_to_sign_in'),
                onTap: () => context.go(AppRoutes.login),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon(AppColors colors) {
    return Center(
      child: Container(
        width: 120.w,
        height: 120.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.success50,
        ),
        child: Center(
          child: Container(
            width: 80.w,
            height: 80.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: splashOrange,
            ),
            child: Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 44.w,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(AppColors colors) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 20.w,
            color: colors.neutral500,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              tr('salon_auth.success_info'),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: colors.neutral600,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
