import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/shared/domain/entities/category.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';

class PackagesFilterSheet extends StatefulWidget {
  const PackagesFilterSheet({
    super.key,
    required this.colors,
    required this.categories,
    required this.initialCategoryIds,
    required this.initialSortBy,
    required this.onApply,
  });

  final AppColors colors;
  final List<Category> categories;
  final List<int> initialCategoryIds;
  final List<String> initialSortBy;
  final void Function(List<int> categoryIds, List<String> sortBy) onApply;

  @override
  State<PackagesFilterSheet> createState() => _PackagesFilterSheetState();
}

class _PackagesFilterSheetState extends State<PackagesFilterSheet> {
  late List<int> _categoryIds;
  late List<String> _sortBy;

  @override
  void initState() {
    super.initState();
    _categoryIds = List.of(widget.initialCategoryIds);
    _sortBy = List.of(widget.initialSortBy);
  }

  void _toggleSort(String value) {
    setState(() {
      if (_sortBy.contains(value)) {
        _sortBy.remove(value);
      } else {
        _sortBy.add(value);
      }
    });
  }

  void _toggleCategory(int id) {
    setState(() {
      if (_categoryIds.contains(id)) {
        _categoryIds.remove(id);
      } else {
        _categoryIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20.w,
        16.h,
        20.w,
        MediaQuery.of(context).viewInsets.bottom + 24.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: colors.neutral300,
                borderRadius: BorderRadius.circular(999.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tr('packages_list.filter_title'),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.neutral900,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  _categoryIds = [];
                  _sortBy = [];
                }),
                child: Text(
                  tr('packages_list.filter_clear'),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: splashOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            tr('packages_list.sort_by'),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: colors.neutral800,
            ),
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            children: [
              _FilterChip(
                label: tr('packages_list.sort_nearest'),
                active: _sortBy.contains('nearest'),
                colors: colors,
                onTap: () => _toggleSort('nearest'),
              ),
              _FilterChip(
                label: tr('packages_list.sort_highest_rated'),
                active: _sortBy.contains('highest_rated'),
                colors: colors,
                onTap: () => _toggleSort('highest_rated'),
              ),
            ],
          ),
          if (widget.categories.isNotEmpty) ...[
            SizedBox(height: 20.h),
            Text(
              tr('packages_list.categories'),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: colors.neutral800,
              ),
            ),
            SizedBox(height: 10.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: widget.categories
                  .map((c) => _FilterChip(
                        label: c.name,
                        active: _categoryIds.contains(c.id),
                        colors: colors,
                        onTap: () => _toggleCategory(c.id),
                      ))
                  .toList(),
            ),
          ],
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: splashOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                widget.onApply(_categoryIds, _sortBy);
              },
              child: Text(
                tr('packages_list.filter_apply'),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.active,
    required this.colors,
    required this.onTap,
  });

  final String label;
  final bool active;
  final AppColors colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: active ? splashOrange : colors.neutral100,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: active ? splashOrange : colors.neutral300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            color: active ? Colors.white : colors.neutral700,
          ),
        ),
      ),
    );
  }
}
