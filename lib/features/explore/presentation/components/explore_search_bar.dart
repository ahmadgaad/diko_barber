import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ronaq_barber/core/resources/svg_resources.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';

class ExploreSearchBar extends StatelessWidget {
  const ExploreSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      height: 46.h,
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: Row(
        children: [
          SizedBox(width: 12.w),
          SvgPicture.asset(
            SvgResources.search,
            width: 18.r,
            height: 18.r,
            colorFilter: ColorFilter.mode(colors.neutral400, BlendMode.srcIn),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              onTapOutside: (_) => focusNode.unfocus(),
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              style: TextStyle(fontSize: 14.sp, color: colors.neutral900),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: tr('explore.search_hint'),
                hintStyle: TextStyle(fontSize: 14.sp, color: colors.neutral400),
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (_, value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return GestureDetector(
                onTap: onClear,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Container(
                    width: 18.r,
                    height: 18.r,
                    decoration: BoxDecoration(
                      color: colors.neutral300,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 11.r,
                      color: colors.neutral700,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
