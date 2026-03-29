import 'package:diko_barber/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.onChanged,
    this.errorText,
    this.isRequired = false,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
  });

  final String label;
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final bool isRequired;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLabel(colors),
        SizedBox(height: 8.h),
        _buildTextField(colors, hasError),
        if (hasError) ...[
          SizedBox(height: 8.h),
          _buildErrorText(colors),
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

  Widget _buildTextField(AppColors colors, bool hasError) {
    final borderColor = hasError ? colors.error500 : colors.neutral300;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: colors.neutral900,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: colors.neutral500,
        ),
        suffixIcon: suffixIcon,
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
          borderSide:
              BorderSide(color: hasError ? colors.error500 : splashOrange),
        ),
      ),
    );
  }

  Widget _buildErrorText(AppColors colors) {
    return Text(
      errorText!,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: colors.error500,
      ),
    );
  }
}
