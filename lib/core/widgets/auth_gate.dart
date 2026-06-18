import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zain/core/di/service_locator.dart';
import 'package:zain/core/router/app_routes.dart';
import 'package:zain/core/services/user_session.dart';
import 'package:zain/core/theme/app_colors.dart';

abstract final class AuthGate {
  /// Shows the auth bottom sheet immediately.
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (_) => const _AuthGateSheet(),
    );
  }

  /// Checks auth; if authenticated runs [action], else shows the gate.
  static Future<void> guard(BuildContext context, VoidCallback action) async {
    final isAuth = await sl<UserSession>().isAuthenticated;
    if (!context.mounted) return;
    if (isAuth) {
      action();
    } else {
      show(context);
    }
  }
}

class _AuthGateSheet extends StatelessWidget {
  const _AuthGateSheet();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
      decoration: BoxDecoration(
        color: colors.neutral50,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: colors.neutral300,
              borderRadius: BorderRadius.circular(999.r),
            ),
          ),
          SizedBox(height: 24.h),
          // Icon
          Container(
            width: 64.r,
            height: 64.r,
            decoration: BoxDecoration(
              color: splashOrange.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline_rounded,
              size: 32.r,
              color: splashOrange,
            ),
          ),
          SizedBox(height: 16.h),
          // Title
          Text(
            tr('auth_gate.title'),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: colors.neutral900,
            ),
          ),
          SizedBox(height: 8.h),
          // Body
          Text(
            tr('auth_gate.body'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: colors.neutral500,
              height: 1.5,
            ),
          ),
          SizedBox(height: 28.h),
          // Sign in button
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              context.push(AppRoutes.login);
            },
            child: Container(
              width: double.infinity,
              height: 52.h,
              decoration: const BoxDecoration(
                gradient: buttonGradient,
                borderRadius: BorderRadius.all(Radius.circular(999)),
              ),
              alignment: Alignment.center,
              child: Text(
                tr('auth_gate.sign_in'),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Create account button
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              context.push(AppRoutes.signup);
            },
            child: Container(
              width: double.infinity,
              height: 52.h,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(999.r),
                border: Border.all(color: colors.neutral300),
              ),
              alignment: Alignment.center,
              child: Text(
                tr('auth_gate.create_account'),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.neutral800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
