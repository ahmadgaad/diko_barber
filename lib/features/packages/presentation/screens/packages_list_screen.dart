import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ronaq_barber/core/di/service_locator.dart';
import 'package:ronaq_barber/core/shared/domain/entities/category.dart';
import 'package:ronaq_barber/core/shared/domain/entities/nearest_package.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/features/packages/presentation/cubit/packages_list_cubit.dart';
import 'package:ronaq_barber/features/packages/presentation/cubit/packages_list_state.dart';
import 'package:shimmer/shimmer.dart';

enum _LayoutMode { grid, list }

class PackagesListScreen extends StatelessWidget {
  const PackagesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PackagesListCubit>(),
      child: const _PackagesListView(),
    );
  }
}

class _PackagesListView extends StatefulWidget {
  const _PackagesListView();

  @override
  State<_PackagesListView> createState() => _PackagesListViewState();
}

class _PackagesListViewState extends State<_PackagesListView> {
  _LayoutMode _mode = _LayoutMode.grid;
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
          child: Icon(Icons.arrow_back_ios_new_rounded,
              size: 20.r, color: colors.neutral900),
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
          // Layout toggle
          Padding(
            padding: EdgeInsetsDirectional.only(end: 12.w),
            child: GestureDetector(
              onTap: () => setState(() {
                _mode = _mode == _LayoutMode.grid
                    ? _LayoutMode.list
                    : _LayoutMode.grid;
              }),
              child: Icon(
                _mode == _LayoutMode.grid
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
          // Search bar + filter button
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
            child: Row(
              children: [
                Expanded(
                  child: _SearchBar(
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
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GestureDetector(
                          onTap: () => _showFilterSheet(context, colors),
                          child: Container(
                            width: 44.h,
                            height: 44.h,
                            decoration: BoxDecoration(
                              color: count > 0
                                  ? splashOrange
                                  : colors.neutral100,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: count > 0
                                    ? splashOrange
                                    : colors.neutral300,
                              ),
                            ),
                            child: Icon(
                              Icons.tune_rounded,
                              size: 20.r,
                              color: count > 0
                                  ? Colors.white
                                  : colors.neutral700,
                            ),
                          ),
                        ),
                        if (count > 0)
                          PositionedDirectional(
                            top: -4.h,
                            end: -4.w,
                            child: Container(
                              width: 16.r,
                              height: 16.r,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE53935),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$count',
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                      ],
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
                  _PackagesShimmer(colors: colors, mode: _mode),
                PackagesListError() => _PackagesError(colors: colors),
                PackagesListLoaded() =>
                  _PackagesContent(state: state, colors: colors, mode: _mode),
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
      builder: (_) => _FilterSheet(
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

// ── Search bar ────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({
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
          prefixIcon:
              Icon(Icons.search_rounded, size: 20.r, color: colors.neutral400),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, _) => value.text.isEmpty
                ? const SizedBox.shrink()
                : GestureDetector(
                    onTap: () {
                      controller.clear();
                      onChanged('');
                    },
                    child: Icon(Icons.close_rounded,
                        size: 18.r, color: colors.neutral400),
                  ),
          ),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
        ),
      ),
    );
  }
}

// ── Filter bottom sheet ───────────────────────────────────────────────────────

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({
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
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
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
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w,
          MediaQuery.of(context).viewInsets.bottom + 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
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
          // Title row
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
                onTap: () {
                  setState(() {
                    _categoryIds = [];
                    _sortBy = [];
                  });
                },
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
          // Sort by
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
          // Apply button
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

// ── Content (grid or list) ────────────────────────────────────────────────────

class _PackagesContent extends StatelessWidget {
  const _PackagesContent({
    required this.state,
    required this.colors,
    required this.mode,
  });
  final PackagesListLoaded state;
  final AppColors colors;
  final _LayoutMode mode;

  @override
  Widget build(BuildContext context) {
    if (state.packages.isEmpty) {
      return Center(
        child: Text(
          tr('explore.no_results_title'),
          style: TextStyle(fontSize: 14.sp, color: colors.neutral500),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n is ScrollEndNotification &&
            n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
          context.read<PackagesListCubit>().loadMore();
        }
        return false;
      },
      child: RefreshIndicator(
        color: splashOrange,
        onRefresh: () => context.read<PackagesListCubit>().refresh(),
        child: CustomScrollView(
          slivers: [
            if (mode == _LayoutMode.grid)
              _GridSliver(state: state, colors: colors)
            else
              _ListSliver(state: state, colors: colors),
            if (state.isLoadingMore)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Center(
                    child: SizedBox(
                      width: 24.r,
                      height: 24.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: splashOrange,
                      ),
                    ),
                  ),
                ),
              ),
            if (state.loadMoreFailed)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Center(
                    child: TextButton(
                      onPressed: () =>
                          context.read<PackagesListCubit>().loadMore(),
                      child: Text(
                        tr('explore.load_more_failed'),
                        style: TextStyle(color: splashOrange),
                      ),
                    ),
                  ),
                ),
              ),
            SliverToBoxAdapter(child: SizedBox(height: 24.h)),
          ],
        ),
      ),
    );
  }
}

// ── Grid sliver ───────────────────────────────────────────────────────────────

class _GridSliver extends StatelessWidget {
  const _GridSliver({required this.state, required this.colors});
  final PackagesListLoaded state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          mainAxisExtent: 240.h,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) => GestureDetector(
            onTap: () => context.push('/package/${state.packages[i].id}'),
            child: _GridCard(package: state.packages[i], colors: colors),
          ),
          childCount: state.packages.length,
        ),
      ),
    );
  }
}

// ── List sliver ───────────────────────────────────────────────────────────────

class _ListSliver extends StatelessWidget {
  const _ListSliver({required this.state, required this.colors});
  final PackagesListLoaded state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: GestureDetector(
              onTap: () => context.push('/package/${state.packages[i].id}'),
              child: _ListCard(package: state.packages[i], colors: colors),
            ),
          ),
          childCount: state.packages.length,
        ),
      ),
    );
  }
}

// ── Grid card ─────────────────────────────────────────────────────────────────

class _GridCard extends StatelessWidget {
  const _GridCard({required this.package, required this.colors});
  final NearestPackage package;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.neutral50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.neutral200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GridImage(package: package, colors: colors),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.r),
              child: _GridInfo(package: package, colors: colors),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridImage extends StatelessWidget {
  const _GridImage({required this.package, required this.colors});
  final NearestPackage package;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: package.image,
          width: double.infinity,
          height: 130.h,
          fit: BoxFit.cover,
          placeholder: (_, _) => Container(
              width: double.infinity, height: 130.h, color: colors.neutral200),
          errorWidget: (_, _, _) => Container(
            width: double.infinity,
            height: 130.h,
            color: colors.neutral200,
            alignment: Alignment.center,
            child: Icon(Icons.spa_outlined,
                color: colors.neutral400, size: 32.r),
          ),
        ),
        if (package.hasDiscount)
          PositionedDirectional(
            top: 8.h,
            start: 8.w,
            child: _DiscountBadge(package: package),
          ),
        PositionedDirectional(
          top: 8.h,
          end: 8.w,
          child: _FavButton(package: package, size: 26.r, iconSize: 14.r),
        ),
      ],
    );
  }
}

class _GridInfo extends StatelessWidget {
  const _GridInfo({required this.package, required this.colors});
  final NearestPackage package;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                package.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.neutral900,
                  height: 1.3,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.access_time_rounded,
                    size: 10.r, color: colors.neutral500),
                SizedBox(width: 2.w),
                Text(
                  '${package.durationMinutes} ${tr('home.min')}',
                  style:
                      TextStyle(fontSize: 10.sp, color: colors.neutral500),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Icon(Icons.storefront_outlined,
                size: 11.r, color: colors.neutral500),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                package.salon.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(fontSize: 10.sp, color: colors.neutral500),
              ),
            ),
          ],
        ),
        const Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${package.effectivePrice.toStringAsFixed(0)} ${tr('home.currency')}',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: splashOrange,
              ),
            ),
            if (package.hasDiscount) ...[
              SizedBox(width: 4.w),
              Text(
                package.price.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 10.sp,
                  color: colors.neutral400,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: colors.neutral400,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

// ── List card ─────────────────────────────────────────────────────────────────

class _ListCard extends StatelessWidget {
  const _ListCard({required this.package, required this.colors});
  final NearestPackage package;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        color: colors.neutral50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.neutral200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          // Image with discount badge only
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: package.image,
                width: 100.h,
                height: 100.h,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                    width: 100.h, height: 100.h, color: colors.neutral200),
                errorWidget: (_, _, _) => Container(
                  width: 100.h,
                  height: 100.h,
                  color: colors.neutral200,
                  alignment: Alignment.center,
                  child: Icon(Icons.spa_outlined,
                      color: colors.neutral400, size: 28.r),
                ),
              ),
              if (package.hasDiscount)
                PositionedDirectional(
                  top: 6.h,
                  start: 6.w,
                  child: _DiscountBadge(package: package),
                ),
              PositionedDirectional(
                top: 6.h,
                end: 6.w,
                child: _FavButton(package: package, size: 24.r, iconSize: 13.r),
              ),
            ],
          ),
          // Info
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          package.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: colors.neutral900,
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Icon(Icons.favorite_border_rounded,
                          size: 18.r, color: colors.neutral400),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Icon(Icons.storefront_outlined,
                          size: 11.r, color: colors.neutral500),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          package.salon.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 11.sp, color: colors.neutral500),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 11.r, color: colors.neutral500),
                      SizedBox(width: 2.w),
                      Text(
                        '${package.durationMinutes} ${tr('home.min')}',
                        style: TextStyle(
                            fontSize: 11.sp, color: colors.neutral500),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${package.effectivePrice.toStringAsFixed(0)} ${tr('home.currency')}',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w800,
                              color: splashOrange,
                            ),
                          ),
                          if (package.hasDiscount)
                            Text(
                              package.price.toStringAsFixed(0),
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: colors.neutral400,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: colors.neutral400,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _DiscountBadge extends StatelessWidget {
  const _DiscountBadge({required this.package});
  final NearestPackage package;

  String get _label {
    final d = package.discount;
    if (d == null) return '';
    if (d.type == 'percentage') return '-${d.value.toStringAsFixed(0)}%';
    return '-${d.value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE53935),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        _label,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _FavButton extends StatelessWidget {
  const _FavButton({
    required this.package,
    required this.size,
    required this.iconSize,
  });
  final NearestPackage package;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.read<PackagesListCubit>().toggleFavorite(package.id),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(
          package.isFavorite
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          color: package.isFavorite ? Colors.red : Colors.white,
          size: iconSize,
        ),
      ),
    );
  }
}

// ── Shimmer ───────────────────────────────────────────────────────────────────

class _PackagesShimmer extends StatelessWidget {
  const _PackagesShimmer({required this.colors, required this.mode});
  final AppColors colors;
  final _LayoutMode mode;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: colors.neutral200,
      highlightColor: colors.neutral100,
      child: mode == _LayoutMode.grid
          ? _GridShimmer(colors: colors)
          : _ListShimmer(colors: colors),
    );
  }
}

class _GridShimmer extends StatelessWidget {
  const _GridShimmer({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 16.h),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        mainAxisExtent: 240.h,
      ),
      itemCount: 6,
      itemBuilder: (_, _) => Container(
        decoration: BoxDecoration(
          color: colors.neutral200,
          borderRadius: BorderRadius.circular(16.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: double.infinity,
                height: 130.h,
                color: colors.neutral300),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: colors.neutral200,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Container(
                      width: 80.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: colors.neutral200,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 60.w,
                      height: 13.h,
                      decoration: BoxDecoration(
                        color: colors.neutral200,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListShimmer extends StatelessWidget {
  const _ListShimmer({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 16.h),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemBuilder: (_, _) => Container(
        height: 100.h,
        decoration: BoxDecoration(
          color: colors.neutral200,
          borderRadius: BorderRadius.circular(16.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Container(width: 100.h, color: colors.neutral300),
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 13.h,
                      decoration: BoxDecoration(
                        color: colors.neutral300,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Container(
                      width: 100.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: colors.neutral300,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 70.w,
                      height: 13.h,
                      decoration: BoxDecoration(
                        color: colors.neutral300,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error ─────────────────────────────────────────────────────────────────────

class _PackagesError extends StatelessWidget {
  const _PackagesError({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded,
              size: 48.r, color: colors.neutral400),
          SizedBox(height: 12.h),
          Text(
            tr('explore.error_body'),
            style: TextStyle(fontSize: 14.sp, color: colors.neutral600),
          ),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: () => context.read<PackagesListCubit>().refresh(),
            child: Text(
              tr('package_details.retry'),
              style: TextStyle(color: splashOrange),
            ),
          ),
        ],
      ),
    );
  }
}
