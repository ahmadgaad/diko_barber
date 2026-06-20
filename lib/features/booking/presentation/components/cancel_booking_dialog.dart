import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/core/widgets/app_gradient_button.dart';

class CancelBookingDialog extends StatefulWidget {
  const CancelBookingDialog({super.key, required this.colors});

  final AppColors colors;

  static Future<String?> show(BuildContext context, AppColors colors) {
    return showDialog<String>(
      context: context,
      builder: (_) => CancelBookingDialog(colors: colors),
    );
  }

  @override
  State<CancelBookingDialog> createState() => _CancelBookingDialogState();
}

class _CancelBookingDialogState extends State<CancelBookingDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;
    return Dialog(
      backgroundColor: colors.neutral50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cancel_outlined,
              size: 48.r,
              color: colors.error600,
            ),
            SizedBox(height: 16.h),
            Text(
              tr('bookings.cancel_title'),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: colors.neutral900,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              tr('bookings.cancel_subtitle'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: colors.neutral500,
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: tr('bookings.cancel_reason_hint'),
                hintStyle: TextStyle(
                  fontSize: 13.sp,
                  color: colors.neutral400,
                ),
                filled: true,
                fillColor: colors.neutral100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: colors.neutral200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: colors.neutral200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: splashOrange),
                ),
                contentPadding: EdgeInsets.all(12.r),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      height: 44.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999.r),
                        border: Border.all(color: colors.neutral300),
                      ),
                      child: Text(
                        tr('bookings.cancel_no'),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.neutral700,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: AppGradientButton(
                    label: tr('bookings.cancel_yes'),
                    onTap: () {
                      final reason = _controller.text.trim();
                      Navigator.of(context).pop(
                        reason.isEmpty ? 'لا يوجد سبب' : reason,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
