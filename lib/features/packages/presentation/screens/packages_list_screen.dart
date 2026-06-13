import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/features/packages/presentation/components/packages_content.dart';
import 'package:ronaq_barber/features/packages/presentation/components/packages_error_view.dart';
import 'package:ronaq_barber/features/packages/presentation/components/packages_filter_button.dart';
import 'package:ronaq_barber/features/packages/presentation/components/packages_filter_sheet.dart';
import 'package:ronaq_barber/features/packages/presentation/components/packages_layout_mode.dart';
import 'package:ronaq_barber/features/packages/presentation/components/packages_search_bar.dart';
import 'package:ronaq_barber/features/packages/presentation/components/packages_shimmer.dart';
import 'package:ronaq_barber/features/packages/presentation/cubit/packages_list_cubit.dart';
import 'package:ronaq_barber/features/packages/presentation/cubit/packages_list_state.dart';

class PackagesListScreen extends StatefulWidget {
  const PackagesListScreen({super.key});

  @override
  State<PackagesListScreen> createState() => _PackagesListScreenState();
}

class _PackagesListScreenState extends State<PackagesListScreen> {
  PackagesLayoutMode _mode = PackagesLayoutMode.grid;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.neutral50,
      appBar: AppBar(
        backgroundColor: colors.neutral50,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20.r,
            color: colors.neutral900,
          ),
        ),
        title: Text(
          tr('home.featured_packages'),
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: colors.neutral900,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 12.w),
            child: GestureDetector(
              onTap: () => setState(() {
                _mode = _mode == PackagesLayoutMode.grid
                    ? PackagesLayoutMode.list
                    : PackagesLayoutMode.grid;
              }),
              child: Icon(
                _mode == PackagesLayoutMode.grid
                    ? Icons.view_list_rounded
                    : Icons.grid_view_rounded,
                size: 22.r,
                color: colors.neutral900,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
            child: Row(
              children: [
                Expanded(
                  child: PackagesSearchBar(
                    controller: _searchController,
                    colors: colors,
                    onChanged: (v) =>
                        context.read<PackagesListCubit>().updateSearch(v),
                  ),
                ),
                SizedBox(width: 10.w),
                BlocBuilder<PackagesListCubit, PackagesListState>(
                  buildWhen: (p, c) {
                    if (c is PackagesListLoaded) {
                      if (p is PackagesListLoaded) {
                        return p.activeFiltersCount != c.activeFiltersCount;
                      }
                      return true;
                    }
                    return false;
                  },
                  builder: (context, state) {
                    final count = state is PackagesListLoaded
                        ? state.activeFiltersCount
                        : 0;
                    return PackagesFilterButton(
                      colors: colors,
                      activeCount: count,
                      onTap: () => _showFilterSheet(context, colors),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<PackagesListCubit, PackagesListState>(
              builder: (context, state) => switch (state) {
                PackagesListLoading() =>
                  PackagesShimmer(colors: colors, mode: _mode),
                PackagesListError() => PackagesErrorView(colors: colors),
                PackagesListLoaded() =>
                  PackagesContent(state: state, colors: colors, mode: _mode),
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context, AppColors colors) {
    final cubit = context.read<PackagesListCubit>();
    final currentState = cubit.state;
    final currentCategoryIds = currentState is PackagesListLoaded
        ? currentState.categoryIds
        : <int>[];
    final currentSortBy =
        currentState is PackagesListLoaded ? currentState.sortBy : <String>[];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.neutral50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => PackagesFilterSheet(
        colors: colors,
        categories: cubit.categories,
        initialCategoryIds: currentCategoryIds,
        initialSortBy: currentSortBy,
        onApply: (categoryIds, sortBy) {
          cubit.applyFilters(categoryIds: categoryIds, sortBy: sortBy);
        },
      ),
    );
  }
}
