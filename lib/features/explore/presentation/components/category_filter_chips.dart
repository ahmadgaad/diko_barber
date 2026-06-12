import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/shared/domain/entities/category.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/features/explore/presentation/cubit/explore_cubit.dart';

class CategoryFilterChips extends StatefulWidget {
  const CategoryFilterChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
  });

  final List<Category> categories;
  final Category? selectedCategory;

  @override
  State<CategoryFilterChips> createState() => _CategoryFilterChipsState();
}

class _CategoryFilterChipsState extends State<CategoryFilterChips> {
  // Keyed by category ID; null key is the "All" chip.
  final Map<int?, GlobalKey> _chipKeys = {};

  @override
  void initState() {
    super.initState();
    _buildKeys();
    if (widget.selectedCategory != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
    }
  }

  @override
  void didUpdateWidget(CategoryFilterChips old) {
    super.didUpdateWidget(old);
    _buildKeys();
    if (widget.selectedCategory?.id != old.selectedCategory?.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
    }
  }

  void _buildKeys() {
    _chipKeys[null] ??= GlobalKey();
    for (final c in widget.categories) {
      _chipKeys[c.id] ??= GlobalKey();
    }
  }

  void _scrollToSelected() {
    final key = _chipKeys[widget.selectedCategory?.id];
    final ctx = key?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      alignment: 0.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _FilterChip(
            chipKey: _chipKeys[null]!,
            label: tr('explore.all'),
            isSelected: widget.selectedCategory == null,
            colors: colors,
            onTap: () => context.read<ExploreCubit>().selectCategory(null),
          ),
          ...widget.categories.map((category) {
            return Padding(
              padding: EdgeInsetsDirectional.only(start: 8.w),
              child: _FilterChip(
                chipKey: _chipKeys[category.id]!,
                label: category.name,
                isSelected: widget.selectedCategory?.id == category.id,
                colors: colors,
                onTap: () =>
                    context.read<ExploreCubit>().selectCategory(category),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.chipKey,
    required this.label,
    required this.isSelected,
    required this.colors,
    required this.onTap,
  });

  final GlobalKey chipKey;
  final String label;
  final bool isSelected;
  final AppColors colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: chipKey,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? splashOrange : colors.neutral100,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: isSelected ? splashOrange : colors.neutral200,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : colors.neutral700,
          ),
        ),
      ),
    );
  }
}
