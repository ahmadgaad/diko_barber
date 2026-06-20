import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';

class AppCupertinoSelectField<T> extends StatelessWidget {
  const AppCupertinoSelectField({
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

  bool get _enabled => !isLoading && items.isNotEmpty && onChanged != null;

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
        GestureDetector(
          onTap: _enabled ? () => _openPicker(context, colors) : null,
          child: Container(
            height: 52.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: colors.neutral50,
              borderRadius: BorderRadius.circular(999.r),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value != null ? itemLabel(value as T) : hint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: value != null
                          ? colors.neutral900
                          : colors.neutral500,
                    ),
                  ),
                ),
                if (isLoading)
                  SizedBox(
                    height: 16.h,
                    width: 16.h,
                    child: const CircularProgressIndicator.adaptive(
                      strokeWidth: 2,
                    ),
                  )
                else
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: colors.neutral500,
                  ),
              ],
            ),
          ),
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

  Future<void> _openPicker(BuildContext context, AppColors colors) async {
    final initialIndex = value != null ? items.indexOf(value as T) : 0;
    var selectedIndex = initialIndex < 0 ? 0 : initialIndex;

    final result = await showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: colors.neutral50,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header: Cancel | label | Done
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: colors.neutral200),
                  ),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(sheetContext).pop(),
                      child: Text(
                        tr('picker.cancel'),
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: colors.neutral500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.neutral900,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.of(sheetContext).pop(items[selectedIndex]),
                      child: Text(
                        tr('picker.done'),
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: splashOrange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 240.h,
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedIndex,
                  ),
                  itemExtent: 50.h,
                  onSelectedItemChanged: (index) => selectedIndex = index,
                  children: items
                      .map(
                        (item) => Center(
                          child: Text(
                            itemLabel(item),
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: colors.neutral900,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: MediaQuery.paddingOf(context).bottom),
            ],
          ),
        );
      },
    );

    if (result != null) onChanged?.call(result);
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
