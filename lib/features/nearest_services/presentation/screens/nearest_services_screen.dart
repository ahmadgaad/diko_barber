import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/di/service_locator.dart';
import 'package:ronaq_barber/core/shared/domain/entities/nearest_service.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

import '../cubit/nearest_services_list_cubit.dart';
import '../cubit/nearest_services_list_state.dart';

class NearestServicesScreen extends StatelessWidget {
  const NearestServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NearestServicesListCubit>(),
      child: const _NearestServicesView(),
    );
  }
}

class _NearestServicesView extends StatefulWidget {
  const _NearestServicesView();

  @override
  State<_NearestServicesView> createState() => _NearestServicesViewState();
}

class _NearestServicesViewState extends State<_NearestServicesView> {
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
      context.read<NearestServicesListCubit>().loadMore();
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
          tr('home.featured_services'),
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: colors.neutral900,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<NearestServicesListCubit, NearestServicesListState>(
        builder: (context, state) => switch (state) {
          NearestServicesListLoading() => _ServicesGridShimmer(colors: colors),
          NearestServicesListError() => _ErrorView(
              onRetry: () =>
                  context.read<NearestServicesListCubit>().refresh(),
              colors: colors,
            ),
          NearestServicesListLoaded(:final services, :final isLoadingMore) =>
            services.isEmpty
                ? _EmptyView(colors: colors)
                : RefreshIndicator(
                    color: splashOrange,
                    onRefresh: () =>
                        context.read<NearestServicesListCubit>().refresh(),
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: services.length + (isLoadingMore ? 2 : 0),
                      itemBuilder: (context, index) {
                        if (index >= services.length) {
                          return _ShimmerCard(colors: colors);
                        }
                        return _ServiceCard(
                          service: services[index],
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

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service, required this.colors});
  final NearestService service;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final hasDiscount = service.hasDiscount;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: service.image,
            fit: BoxFit.cover,
            placeholder: (_, _) => Container(color: colors.neutral200),
            errorWidget: (_, _, _) => Container(
              color: colors.neutral200,
              child: Icon(Icons.content_cut_outlined,
                  color: colors.neutral400, size: 36.r),
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
                if (service.categoryName != null)
                  Container(
                    margin: EdgeInsets.only(bottom: 4.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      service.categoryName!,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                Text(
                  service.name,
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
                  service.salon.name,
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
                        '${service.effectivePrice.toStringAsFixed(0)} ${tr('home.currency')}',
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
                        service.price.toStringAsFixed(0),
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

class _ServicesGridShimmer extends StatelessWidget {
  const _ServicesGridShimmer({required this.colors});
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
        tr('home.no_services'),
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
