import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/core/widgets/app_gradient_button.dart';

typedef SalonRating = ({int rating, String comment});

class RateSalonDialog extends StatefulWidget {
  const RateSalonDialog({
    super.key,
    required this.salonName,
    required this.colors,
  });

  final String salonName;
  final AppColors colors;

  static Future<SalonRating?> show(
    BuildContext context,
    AppColors colors, {
    required String salonName,
  }) {
    return showDialog<SalonRating>(
      context: context,
      builder: (_) => RateSalonDialog(salonName: salonName, colors: colors),
    );
  }

  @override
  State<RateSalonDialog> createState() => _RateSalonDialogState();
}

class _RateSalonDialogState extends State<RateSalonDialog> {
  final _controller = TextEditingController();
  int _rating = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_rating == 0) return;
    Navigator.of(context).pop((
      rating: _rating,
      comment: _controller.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;
    return Dialog(
      backgroundColor: colors.neutral50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_rounded, size: 48.r, color: splashOrange),
            SizedBox(height: 16.h),
            Text(
              tr('bookings.rate_title'),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: colors.neutral900,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              tr('bookings.rate_subtitle', namedArgs: {'name': widget.salonName}),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: colors.neutral500),
            ),
            SizedBox(height: 16.h),
            _StarRow(
              rating: _rating,
              onChanged: (value) => setState(() => _rating = value),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: tr('bookings.rate_comment_hint'),
                hintStyle: TextStyle(fontSize: 13.sp, color: colors.neutral400),
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
                        tr('bookings.cancel'),
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
                    label: tr('bookings.rate_submit'),
                    enabled: _rating > 0,
                    onTap: _submit,
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

class _StarRow extends StatelessWidget {
  const _StarRow({required this.rating, required this.onChanged});

  final int rating;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final value = index + 1;
        final filled = value <= rating;
        return GestureDetector(
          onTap: () => onChanged(value),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Icon(
              filled ? Icons.star_rounded : Icons.star_outline_rounded,
              size: 36.r,
              color: filled ? splashOrange : AppColors.of(context).neutral300,
            ),
          ),
        );
      }),
    );
  }
}
