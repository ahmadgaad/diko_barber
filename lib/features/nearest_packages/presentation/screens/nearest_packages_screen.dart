import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/di/service_locator.dart';
import 'package:ronaq_barber/core/shared/domain/entities/nearest_package.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

import '../cubit/nearest_packages_list_cubit.dart';
import '../cubit/nearest_packages_list_state.dart';

class NearestPackagesScreen extends StatelessWidget {
  const NearestPackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NearestPackagesListCubit>(),
      child: const _NearestPackagesView(),
    );
  }
}

class _NearestPackagesView extends StatefulWidget {
  const _NearestPackagesView();

  @override
  State<_NearestPackagesView> createState() => _NearestPackagesViewState();
}

class _NearestPackagesViewState extends State<_NearestPackagesView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<NearestPackagesListCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.neutral50,
      appBar: AppBar(
        backgroundColor: colors.neutral50,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          tr('home.featured_packages'),
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: colors.neutral900,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<NearestPackagesListCubit, NearestPackagesListState>(
        builder: (context, state) => switch (state) {
          NearestPackagesListLoading() => _PackagesGridShimmer(colors: colors),
          NearestPackagesListError() => _ErrorView(
              onRetry: () =>
                  context.read<NearestPackagesListCubit>().refresh(),
              colors: colors,
            ),
          NearestPackagesListLoaded(:final packages, :final isLoadingMore) =>
            packages.isEmpty
                ? _EmptyView(colors: colors)
                : RefreshIndicator(
                    color: splashOrange,
                    onRefresh: () =>
                        context.read<NearestPackagesListCubit>().refresh(),
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: packages.length + (isLoadingMore ? 2 : 0),
                      itemBuilder: (context, index) {
                        if (index >= packages.length) {
                          return _ShimmerCard(colors: colors);
                        }
                        return _PackageCard(
                          package: packages[index],
                          colors: colors,
                        );
                      },
                    ),
                  ),
        },
      ),
    );
  }
}

// ── Card ─────────────────────────────────────────────────────────────────────

class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.package, required this.colors});
  final NearestPackage package;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final hasDiscount = package.hasDiscount;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: package.image,
            fit: BoxFit.cover,
            placeholder: (_, _) => Container(color: colors.neutral200),
            errorWidget: (_, _, _) => Container(
              color: colors.neutral200,
              child: Icon(Icons.spa_outlined,
                  color: colors.neutral400, size: 40.r),
            ),
          ),
          // Gradient overlay
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.35, 1.0],
                colors: [Colors.transparent, Color(0xF0000000)],
              ),
            ),
          ),
          // Content
          Positioned(
            left: 10.w,
            right: 10.w,
            bottom: 10.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  package.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  package.salon.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: splashOrange,
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Text(
                        '${package.effectivePrice.toStringAsFixed(0)} ${tr('home.currency')}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (hasDiscount) ...[
                      SizedBox(width: 4.w),
                      Text(
                        package.price.toStringAsFixed(0),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white54,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.white54,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shimmer ───────────────────────────────────────────────────────────────────

class _PackagesGridShimmer extends StatelessWidget {
  const _PackagesGridShimmer({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.72,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => _ShimmerCard(colors: colors),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: colors.neutral200,
      highlightColor: colors.neutral100,
      child: Container(
        decoration: BoxDecoration(
          color: colors.neutral200,
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }
}

// ── Empty / Error ─────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        tr('home.no_packages'),
        style: TextStyle(fontSize: 15.sp, color: colors.neutral500),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry, required this.colors});
  final VoidCallback onRetry;
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
            tr('common.error_retry'),
            style: TextStyle(fontSize: 14.sp, color: colors.neutral500),
          ),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: onRetry,
            child: Text(
              tr('common.retry'),
              style: TextStyle(color: splashOrange, fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }
}
