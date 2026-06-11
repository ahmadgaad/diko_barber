import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/resources/image_resources.dart';
import 'package:ronaq_barber/core/shared/domain/entities/category.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/features/home/presentation/components/section_header.dart';
import 'package:ronaq_barber/features/home/presentation/cubit/categories_cubit.dart';
import 'package:ronaq_barber/features/home/presentation/cubit/categories_state.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) => switch (state) {
        CategoriesLoading() => _CategoriesShimmer(colors: colors),
        CategoriesLoaded(:final categories) when categories.isEmpty =>
          const SizedBox.shrink(),
        CategoriesLoaded(:final categories) =>
          _CategoriesList(categories: categories, colors: colors),
        CategoriesError() => const SizedBox.shrink(),
      },
    );
  }
}

// ── Loaded list ───────────────────────────────────────────────────────────────

class _CategoriesList extends StatelessWidget {
  const _CategoriesList({required this.categories, required this.colors});
  final List<Category> categories;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SectionHeader(titleKey: 'home.categories', colors: colors),
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: categories.map((category) {
              return Padding(
                padding: EdgeInsetsDirectional.only(end: 16.w),
                child: _CategoryItem(category: category, colors: colors),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({required this.category, required this.colors});
  final Category category;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 74.w,
      child: Column(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: category.image,
              width: 74.w,
              height: 74.w,
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(
                width: 74.w,
                height: 74.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.neutral200,
                ),
              ),
              errorWidget: (_, _, _) => Container(
                width: 74.w,
                height: 74.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: buttonGradient,
                ),
                padding: EdgeInsets.all(16.r),
                child: Image.asset(
                  ImageResources.logo,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            category.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: colors.neutral900,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shimmer ───────────────────────────────────────────────────────────────────

class _CategoriesShimmer extends StatelessWidget {
  const _CategoriesShimmer({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header skeleton
          Shimmer.fromColors(
            baseColor: colors.neutral200,
            highlightColor: colors.neutral100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: colors.neutral200,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                Container(
                  width: 70.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: colors.neutral200,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          // Items skeleton — scrollable + clipped to match the real list
          Shimmer.fromColors(
            baseColor: colors.neutral200,
            highlightColor: colors.neutral100,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.hardEdge,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(4, (i) {
                  return Padding(
                    padding: EdgeInsetsDirectional.only(end: 12.w),
                    child: SizedBox(
                      width: 74.w,
                      child: Column(
                        children: [
                          Container(
                            width: 74.w,
                            height: 74.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.neutral200,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            width: 60.w,
                            height: 13.h,
                            decoration: BoxDecoration(
                              color: colors.neutral200,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
