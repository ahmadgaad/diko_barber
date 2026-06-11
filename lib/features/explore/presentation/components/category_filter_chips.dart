import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/features/explore/presentation/cubit/explore_cubit.dart';

class CategoryFilterChips extends StatelessWidget {
  const CategoryFilterChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
  });

  final List<String> categories;
  final String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _FilterChip(
            label: tr('explore.all'),
            isSelected: selectedCategory == null,
            colors: colors,
            onTap: () => context.read<ExploreCubit>().selectCategory(null),
          ),
          ...categories.map((category) {
            return Padding(
              padding: EdgeInsetsDirectional.only(start: 8.w),
              child: _FilterChip(
                label: category,
                isSelected: selectedCategory == category,
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
    required this.label,
    required this.isSelected,
    required this.colors,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final AppColors colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
