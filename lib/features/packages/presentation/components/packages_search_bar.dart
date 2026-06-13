import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';

class PackagesSearchBar extends StatelessWidget {
  const PackagesSearchBar({
    super.key,
    required this.controller,
    required this.colors,
    required this.onChanged,
  });

  final TextEditingController controller;
  final AppColors colors;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(fontSize: 14.sp, color: colors.neutral900),
        decoration: InputDecoration(
          hintText: tr('packages_list.search_hint'),
          hintStyle: TextStyle(fontSize: 14.sp, color: colors.neutral400),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 20.r,
            color: colors.neutral400,
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, _) => value.text.isEmpty
                ? const SizedBox.shrink()
                : GestureDetector(
                    onTap: () {
                      controller.clear();
                      onChanged('');
                    },
                    child: Icon(
                      Icons.close_rounded,
                      size: 18.r,
                      color: colors.neutral400,
                    ),
                  ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 11.h,
          ),
        ),
      ),
    );
  }
}
