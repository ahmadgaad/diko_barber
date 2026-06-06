import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/core/widgets/app_gradient_button.dart';

/// Full-page error view with an optional retry button.
///
/// Use this when an entire screen fails to load (network error, server error).
/// For inline/form errors use [AppSnackBar] or field-level error text instead.
class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    this.message,
    this.onRetry,
  });

  final String? message;

  /// If null, no retry button is shown.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 64.w,
              color: colors.neutral300,
            ),
            SizedBox(height: 20.h),
            Text(
              message ?? tr('errors.something_went_wrong'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: colors.neutral600,
              ),
            ),
            if (onRetry != null) ...[
              SizedBox(height: 28.h),
              SizedBox(
                width: 180.w,
                child: AppGradientButton(
                  label: tr('errors.retry'),
                  onTap: onRetry!,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
