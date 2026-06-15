import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zain/core/shared/domain/entities/favorite_type.dart';
import 'package:zain/core/shared/domain/entities/nearest_package.dart';
import 'package:zain/core/shared/domain/entities/nearest_service.dart';
import 'package:zain/core/shared/domain/entities/salon.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:zain/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:shimmer/shimmer.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
          child: Text(
            tr('nav.favorites'),
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: colors.neutral900,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        _FavoritesTabBar(controller: _tabController, colors: colors),
        Expanded(
          child: BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) => switch (state) {
              FavoritesLoading() => TabBarView(
                  controller: _tabController,
                  children: [
                    _FavoritesShimmer(
                      colors: colors,
                      itemBuilder: (c) => _SalonShimmerTile(colors: c),
                    ),
                    _FavoritesShimmer(
                      colors: colors,
                      itemBuilder: (c) => _PackageShimmerTile(colors: c),
                    ),
                    _FavoritesShimmer(
                      colors: colors,
                      itemBuilder: (c) => _ServiceShimmerTile(colors: c),
                    ),
                  ],
                ),
              FavoritesError() => _ErrorState(colors: colors),
              FavoritesLoaded() => TabBarView(
                  controller: _tabController,
                  children: [
                    _SalonsTab(salons: state.salons, colors: colors),
                    _PackagesTab(packages: state.packages, colors: colors),
                    _ServicesTab(services: state.services, colors: colors),
                  ],
                ),
            },
          ),
        ),
      ],
    );
  }
}

// ── Tab bar ───────────────────────────────────────────────────────────────────

class _FavoritesTabBar extends StatelessWidget {
  const _FavoritesTabBar({
    required this.controller,
    required this.colors,
  });

  final TabController controller;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.neutral200)),
      ),
      child: TabBar(
        controller: controller,
        indicatorColor: splashOrange,
        indicatorWeight: 2,
        labelColor: splashOrange,
        unselectedLabelColor: colors.neutral500,
        labelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        dividerColor: Colors.transparent,
        tabs: [
          Tab(text: tr('favorites.tab_salons')),
          Tab(text: tr('favorites.tab_packages')),
          Tab(text: tr('favorites.tab_services')),
        ],
      ),
    );
  }
}

// ── Salons tab ────────────────────────────────────────────────────────────────

class _SalonsTab extends StatelessWidget {
  const _SalonsTab({required this.salons, required this.colors});

  final List<Salon> salons;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    if (salons.isEmpty) {
      return _EmptyState(
        icon: Icons.store_outlined,
        messageKey: 'favorites.empty_salons',
        colors: colors,
      );
    }
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      physics: const BouncingScrollPhysics(),
      itemCount: salons.length,
      separatorBuilder: (_, _) => SizedBox(height: 10.h),
      itemBuilder: (context, i) => _SalonTile(
        salon: salons[i],
        colors: colors,
        onTap: () => context.push('/salon/${salons[i].id}'),
        onFavoriteTap: () => context
            .read<FavoritesCubit>()
            .toggleFavorite(salons[i].id, FavoriteType.salon),
      ),
    );
  }
}

class _SalonTile extends StatelessWidget {
  const _SalonTile({
    required this.salon,
    required this.colors,
    required this.onTap,
    required this.onFavoriteTap,
  });

  final Salon salon;
  final AppColors colors;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: colors.neutral100,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: colors.neutral200),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CachedNetworkImage(
                imageUrl: salon.image,
                width: 72.r,
                height: 72.r,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                    width: 72.r, height: 72.r, color: colors.neutral200),
                errorWidget: (_, _, _) => Container(
                  width: 72.r,
                  height: 72.r,
                  color: colors.neutral200,
                  alignment: Alignment.center,
                  child: Icon(Icons.store_outlined,
                      color: colors.neutral400, size: 26.r),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    salon.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.neutral900,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      Icon(Icons.star_rounded,
                          color: const Color(0xFFFFC107), size: 14.r),
                      SizedBox(width: 3.w),
                      Text(
                        salon.averageRating.toStringAsFixed(1),
                        style: TextStyle(
                            fontSize: 12.sp, color: colors.neutral700),
                      ),
                      SizedBox(width: 8.w),
                      _Dot(colors: colors),
                      SizedBox(width: 8.w),
                      Text(
                        salon.distance?.formatted ?? '-',
                        style: TextStyle(
                            fontSize: 12.sp, color: colors.neutral500),
                      ),
                      SizedBox(width: 8.w),
                      _Dot(colors: colors),
                      SizedBox(width: 8.w),
                      Text(
                        tr(salon.isOpen ? 'home.open' : 'home.closed'),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: salon.isOpen
                              ? colors.success500
                              : colors.error500,
                        ),
                      ),
                    ],
                  ),
                  if (salon.categories.isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 4.w,
                      children: salon.categories.take(3).map((cat) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: colors.neutral50,
                            borderRadius: BorderRadius.circular(999.r),
                            border: Border.all(color: colors.neutral200),
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: colors.neutral700),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: onFavoriteTap,
              child: Icon(Icons.favorite_rounded, color: splashOrange, size: 22.r),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Packages tab ──────────────────────────────────────────────────────────────

class _PackagesTab extends StatelessWidget {
  const _PackagesTab({required this.packages, required this.colors});

  final List<NearestPackage> packages;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    if (packages.isEmpty) {
      return _EmptyState(
        icon: Icons.spa_outlined,
        messageKey: 'favorites.empty_packages',
        colors: colors,
      );
    }
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      physics: const BouncingScrollPhysics(),
      itemCount: packages.length,
      separatorBuilder: (_, _) => SizedBox(height: 10.h),
      itemBuilder: (context, i) => _PackageTile(
        package: packages[i],
        colors: colors,
        onTap: () => context.push('/package/${packages[i].id}'),
        onFavoriteTap: () => context
            .read<FavoritesCubit>()
            .toggleFavorite(packages[i].id, FavoriteType.package),
      ),
    );
  }
}

class _PackageTile extends StatelessWidget {
  const _PackageTile({
    required this.package,
    required this.colors,
    required this.onTap,
    required this.onFavoriteTap,
  });

  final NearestPackage package;
  final AppColors colors;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.neutral100,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: colors.neutral200),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 130.h,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: package.image,
                      fit: BoxFit.cover,
                      placeholder: (_, _) =>
                          Container(color: colors.neutral200),
                      errorWidget: (_, _, _) => Container(
                        color: colors.neutral200,
                        alignment: Alignment.center,
                        child: Icon(Icons.spa_outlined,
                            color: colors.neutral400, size: 32.r),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.55),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10.h,
                      left: 12.w,
                      right: 12.w,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              package.name,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: splashOrange,
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                            child: Text(
                              '${package.price.toInt()} ${tr('home.currency')}',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (package.description.isNotEmpty)
                            Text(
                              package.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: colors.neutral600,
                                  height: 1.4),
                            ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Icon(Icons.store_outlined,
                                  size: 12.r, color: colors.neutral400),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Text(
                                  package.salon.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 11.sp,
                                      color: colors.neutral500),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: splashOrange,
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Text(
                          tr('home.book_now'),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          PositionedDirectional(
            top: 10.h,
            end: 10.w,
            child: GestureDetector(
              onTap: onFavoriteTap,
              child: Container(
                width: 30.r,
                height: 30.r,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.favorite_rounded,
                    color: splashOrange, size: 16.r),
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}

// ── Services tab ──────────────────────────────────────────────────────────────

class _ServicesTab extends StatelessWidget {
  const _ServicesTab({required this.services, required this.colors});

  final List<NearestService> services;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return _EmptyState(
        icon: Icons.content_cut_rounded,
        messageKey: 'favorites.empty_services',
        colors: colors,
      );
    }
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      physics: const BouncingScrollPhysics(),
      itemCount: services.length,
      separatorBuilder: (_, _) => SizedBox(height: 10.h),
      itemBuilder: (context, i) => _ServiceTile(
        service: services[i],
        colors: colors,
        onFavoriteTap: () => context
            .read<FavoritesCubit>()
            .toggleFavorite(services[i].id, FavoriteType.service),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.service,
    required this.colors,
    required this.onFavoriteTap,
  });

  final NearestService service;
  final AppColors colors;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: CachedNetworkImage(
              imageUrl: service.image,
              width: 72.r,
              height: 72.r,
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(
                  width: 72.r, height: 72.r, color: colors.neutral200),
              errorWidget: (_, _, _) => Container(
                width: 72.r,
                height: 72.r,
                color: colors.neutral200,
                alignment: Alignment.center,
                child: Icon(Icons.content_cut_rounded,
                    color: colors.neutral400, size: 24.r),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.neutral900,
                  ),
                ),
                if (service.categoryName != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    service.categoryName!,
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: colors.neutral500,
                        height: 1.4),
                  ),
                ],
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.timer_outlined,
                        size: 13.r, color: colors.neutral400),
                    SizedBox(width: 3.w),
                    Text(
                      '${service.durationMinutes} ${tr('salon_details.min')}',
                      style: TextStyle(
                          fontSize: 11.sp, color: colors.neutral500),
                    ),
                    SizedBox(width: 8.w),
                    Icon(Icons.store_outlined,
                        size: 13.r, color: colors.neutral400),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        service.salon.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 11.sp, color: colors.neutral700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onFavoriteTap,
                child: Icon(Icons.favorite_rounded,
                    color: splashOrange, size: 20.r),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${service.price.toInt()} ${tr('home.currency')}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: splashOrange,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: splashOrange,
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Text(
                        tr('home.book_now'),
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

class _Dot extends StatelessWidget {
  const _Dot({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3.w,
      height: 3.w,
      decoration:
          BoxDecoration(color: colors.neutral400, shape: BoxShape.circle),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.messageKey,
    required this.colors,
  });

  final IconData icon;
  final String messageKey;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64.r, color: colors.neutral300),
          SizedBox(height: 14.h),
          Text(
            tr(messageKey),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: colors.neutral500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.error_outline_rounded,
          size: 56.r, color: colors.neutral300),
    );
  }
}

// ── Shimmer ───────────────────────────────────────────────────────────────────

class _FavoritesShimmer extends StatelessWidget {
  const _FavoritesShimmer({required this.colors, required this.itemBuilder});
  final AppColors colors;
  final Widget Function(AppColors colors) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: List.generate(
          4,
          (_) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: itemBuilder(colors),
          ),
        ),
      ),
    );
  }
}

/// Shimmers only the inner placeholder boxes, keeping the card frame static.
Widget _shimmerContent(AppColors colors, {required Widget child}) {
  return Shimmer.fromColors(
    baseColor: colors.neutral200,
    highlightColor: colors.neutral100,
    child: child,
  );
}

Widget _shimmerBox(
  AppColors colors,
  double width,
  double height, {
  required double radius,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: colors.neutral200,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}

class _SalonShimmerTile extends StatelessWidget {
  const _SalonShimmerTile({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: _shimmerContent(
        colors,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _shimmerBox(colors, 72.r, 72.r, radius: 12.r),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _shimmerBox(colors, 140.w, 15.h, radius: 4.r),
                  SizedBox(height: 8.h),
                  _shimmerBox(colors, 110.w, 12.h, radius: 4.r),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      _shimmerBox(colors, 48.w, 18.h, radius: 999.r),
                      SizedBox(width: 4.w),
                      _shimmerBox(colors, 48.w, 18.h, radius: 999.r),
                      SizedBox(width: 4.w),
                      _shimmerBox(colors, 48.w, 18.h, radius: 999.r),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            _shimmerBox(colors, 22.r, 22.r, radius: 11.r),
          ],
        ),
      ),
    );
  }
}

class _ServiceShimmerTile extends StatelessWidget {
  const _ServiceShimmerTile({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: _shimmerContent(
        colors,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _shimmerBox(colors, 72.r, 72.r, radius: 10.r),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _shimmerBox(colors, double.infinity, 14.h, radius: 4.r),
                  SizedBox(height: 8.h),
                  _shimmerBox(colors, 120.w, 12.h, radius: 4.r),
                  SizedBox(height: 12.h),
                  _shimmerBox(colors, 90.w, 11.h, radius: 4.r),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _shimmerBox(colors, 20.r, 20.r, radius: 10.r),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _shimmerBox(colors, 48.w, 14.h, radius: 4.r),
                    SizedBox(height: 8.h),
                    _shimmerBox(colors, 64.w, 26.h, radius: 999.r),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PackageShimmerTile extends StatelessWidget {
  const _PackageShimmerTile({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.neutral200),
      ),
      clipBehavior: Clip.antiAlias,
      child: _shimmerContent(
        colors,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _shimmerBox(colors, double.infinity, 130.h, radius: 0),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerBox(colors, double.infinity, 12.h, radius: 4.r),
                        SizedBox(height: 6.h),
                        _shimmerBox(colors, 100.w, 11.h, radius: 4.r),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  _shimmerBox(colors, 80.w, 32.h, radius: 999.r),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
