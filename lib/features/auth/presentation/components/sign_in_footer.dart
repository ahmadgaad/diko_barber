import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInFooter extends StatelessWidget {
  const SignInFooter({super.key, required this.onSignUpTap});

  final VoidCallback onSignUpTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Padding(
      padding: EdgeInsets.only(
        top: 16.h,
        bottom: 24.h,
        left: 16.w,
        right: 16.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            tr('auth.no_account'),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: colors.neutral600,
            ),
          ),
          SizedBox(width: 4.w),
          GestureDetector(
            onTap: onSignUpTap,
            child: Text(
              tr('auth.sign_up'),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: splashOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
