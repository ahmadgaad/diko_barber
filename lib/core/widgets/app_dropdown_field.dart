import 'package:zain/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.itemLabel,
    this.value,
    this.onChanged,
    this.errorText,
    this.isRequired = false,
    this.isLoading = false,
  });

  final String label;
  final String hint;
  final List<T> items;
  final String Function(T item) itemLabel;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? errorText;
  final bool isRequired;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final hasError = errorText != null;
    final borderColor = hasError ? colors.error500 : colors.neutral300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLabel(colors),
        SizedBox(height: 8.h),
        DropdownButtonFormField<T>(
          initialValue: value,
          onChanged: isLoading ? null : onChanged,
          hint: isLoading
              ? SizedBox(
                  height: 16.h,
                  width: 16.h,
                  child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                )
              : Text(
                  hint,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: colors.neutral500,
                  ),
                ),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: colors.neutral900,
          ),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: colors.neutral500),
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.neutral50,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 14.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(999.r),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(999.r),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(999.r),
              borderSide: BorderSide(color: hasError ? colors.error500 : splashOrange),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(999.r),
              borderSide: BorderSide(color: colors.error500),
            ),
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(itemLabel(item)),
                ),
              )
              .toList(),
        ),
        if (hasError) ...[
          SizedBox(height: 8.h),
          Text(
            errorText!,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: colors.error500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLabel(AppColors colors) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: colors.neutral900,
          ),
        ),
        if (isRequired) ...[
          SizedBox(width: 4.w),
          Text(
            '*',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: colors.error500,
            ),
          ),
        ],
      ],
    );
  }
}
