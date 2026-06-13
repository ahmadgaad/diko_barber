import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ronaq_barber/core/di/service_locator.dart';
import 'package:ronaq_barber/core/shared/domain/entities/package_details.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/features/package_details/presentation/cubit/package_details_cubit.dart';
import 'package:ronaq_barber/features/package_details/presentation/cubit/package_details_state.dart';
import 'package:shimmer/shimmer.dart';

class PackageDetailsScreen extends StatelessWidget {
  const PackageDetailsScreen({super.key, required this.packageId});
  final int packageId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PackageDetailsCubit>()..load(packageId),
      child: const _PackageDetailsView(),
    );
  }
}

class _PackageDetailsView extends StatelessWidget {
  const _PackageDetailsView();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.neutral50,
      body: BlocBuilder<PackageDetailsCubit, PackageDetailsState>(
        builder: (context, state) => switch (state) {
          PackageDetailsLoading() => _PackageShimmer(colors: colors),
          PackageDetailsError(:final message) => _PackageError(
            message: message,
            colors: colors,
          ),
          PackageDetailsLoaded(:final package) => _PackageContent(
            package: package,
            colors: colors,
          ),
        },
      ),
    );
  }
}

// ── Content ───────────────────────────────────────────────────────────────────

class _PackageContent extends StatelessWidget {
  const _PackageContent({required this.package, required this.colors});
  final PackageDetails package;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            _PackageAppBar(package: package, colors: colors),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PackageHeader(package: package, colors: colors),
                    SizedBox(height: 16.h),
                    _SalonRow(package: package, colors: colors),
                    if (package.description.isNotEmpty) ...[
                      SizedBox(height: 16.h),
                      _Description(text: package.description, colors: colors),
                    ],
                    SizedBox(height: 16.h),
                    _PriceSummary(package: package, colors: colors),
                    SizedBox(height: 24.h),
                    if (package.services.isNotEmpty) ...[
                      _SectionTitle(
                        title: tr('package_details.included_services'),
                        colors: colors,
                      ),
                      SizedBox(height: 12.h),
                      ...package.services.map(
                        (s) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: _ServiceItem(service: s, colors: colors),
                        ),
                      ),
                    ],
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Bottom Book Now bar
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _BookBar(package: package, colors: colors),
        ),
      ],
    );
  }
}

// ── App bar with hero image ───────────────────────────────────────────────────

class _PackageAppBar extends StatelessWidget {
  const _PackageAppBar({required this.package, required this.colors});
  final PackageDetails package;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      scrolledUnderElevation: 0,
      expandedHeight: 240.h,
      pinned: true,
      backgroundColor: colors.neutral50,
      leading: Padding(
        padding: EdgeInsets.all(8.r),
        child: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 18.r,
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsetsDirectional.only(end: 8.w),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                color: Colors.white,
                size: 20.r,
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: package.image,
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(color: colors.neutral300),
              errorWidget: (_, _, _) => Container(
                color: colors.neutral300,
                alignment: Alignment.center,
                child: Icon(
                  Icons.spa_outlined,
                  color: colors.neutral400,
                  size: 48.r,
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.4, 1.0],
                  colors: [Colors.transparent, Color(0xCC000000)],
                ),
              ),
            ),
            if (package.hasDiscount)
              PositionedDirectional(
                bottom: 16.h,
                start: 20.w,
                child: _DiscountBadge(package: package),
              ),
          ],
        ),
      ),
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  const _DiscountBadge({required this.package});
  final PackageDetails package;

  String get _label {
    final d = package.discount;
    if (d == null) return '';
    if (d.type == 'percentage') return '-${d.value.toStringAsFixed(0)}%';
    return '-${d.value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE53935),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        _label,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ── Header: name + specialization ────────────────────────────────────────────

class _PackageHeader extends StatelessWidget {
  const _PackageHeader({required this.package, required this.colors});
  final PackageDetails package;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            package.name,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: colors.neutral900,
              height: 1.2,
            ),
          ),
        ),
        if (package.specialization != null) ...[
          SizedBox(width: 10.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: colors.primary100,
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Text(
              package.specialization!.name,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: colors.primary700,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ── Salon row ─────────────────────────────────────────────────────────────────

class _SalonRow extends StatelessWidget {
  const _SalonRow({required this.package, required this.colors});
  final PackageDetails package;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final salon = package.salon;
    return GestureDetector(
      onTap: () => context.push('/salon/${salon.id}'),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: colors.neutral100,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: colors.neutral200),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedNetworkImage(
                imageUrl: salon.image,
                width: 46.r,
                height: 46.r,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                  width: 46.r,
                  height: 46.r,
                  color: colors.neutral200,
                ),
                errorWidget: (_, _, _) => Container(
                  width: 46.r,
                  height: 46.r,
                  color: colors.neutral200,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.storefront_outlined,
                    size: 22.r,
                    color: colors.neutral400,
                  ),
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
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.neutral900,
                    ),
                  ),
                  if (salon.location != null) ...[
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 12.r,
                          color: colors.neutral500,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            salon.location!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: colors.neutral500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20.r,
              color: colors.neutral400,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Description ───────────────────────────────────────────────────────────────

class _Description extends StatelessWidget {
  const _Description({required this.text, required this.colors});
  final String text;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 13.sp, color: colors.neutral600, height: 1.6),
    );
  }
}

// ── Price summary row ─────────────────────────────────────────────────────────

class _PriceSummary extends StatelessWidget {
  const _PriceSummary({required this.package, required this.colors});
  final PackageDetails package;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: Column(
        children: [
          _InfoTile(
            icon: Icons.attach_money_rounded,
            label: tr('package_details.price'),
            value: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${package.effectivePrice.toStringAsFixed(0)} ${tr('home.currency')}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: splashOrange,
                  ),
                ),
                if (package.hasDiscount) ...[
                  SizedBox(width: 8.w),
                  Text(
                    '${package.price.toStringAsFixed(0)} ${tr('home.currency')}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: colors.neutral400,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: colors.neutral400,
                    ),
                  ),
                ],
              ],
            ),
            colors: colors,
          ),
          if (package.savings != null && package.savings! > 0) ...[
            Divider(height: 16.h, color: colors.neutral200),
            _InfoTile(
              icon: Icons.savings_outlined,
              label: tr('package_details.savings'),
              value: Text(
                '${package.savings!.toStringAsFixed(0)} ${tr('home.currency')}',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.success500,
                ),
              ),
              colors: colors,
            ),
          ],
          Divider(height: 16.h, color: colors.neutral200),
          _InfoTile(
            icon: Icons.access_time_rounded,
            label: tr('package_details.duration'),
            value: Text(
              '${package.durationMinutes} ${tr('home.min')}',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: colors.neutral700,
              ),
            ),
            colors: colors,
          ),
          if (package.servicesTotalPrice != null) ...[
            Divider(height: 16.h, color: colors.neutral200),
            _InfoTile(
              icon: Icons.list_alt_rounded,
              label: tr('package_details.services_value'),
              value: Text(
                '${package.servicesTotalPrice!.toStringAsFixed(0)} ${tr('home.currency')}',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.neutral700,
                ),
              ),
              colors: colors,
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.colors,
  });
  final IconData icon;
  final String label;
  final Widget value;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.r, color: colors.neutral500),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: colors.neutral500),
        ),
        const Spacer(),
        value,
      ],
    );
  }
}

// ── Section title ─────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.colors});
  final String title;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 18.h,
          decoration: BoxDecoration(
            color: splashOrange,
            borderRadius: BorderRadius.circular(999.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: colors.neutral900,
          ),
        ),
      ],
    );
  }
}

// ── Service item card ─────────────────────────────────────────────────────────

class _ServiceItem extends StatelessWidget {
  const _ServiceItem({required this.service, required this.colors});
  final PackageServiceItem service;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: CachedNetworkImage(
              imageUrl: service.image,
              width: 56.r,
              height: 56.r,
              fit: BoxFit.cover,
              placeholder: (_, _) =>
                  Container(width: 56.r, height: 56.r, color: colors.neutral200),
              errorWidget: (_, _, _) => Container(
                width: 56.r,
                height: 56.r,
                color: colors.neutral200,
                alignment: Alignment.center,
                child: Icon(Icons.spa_outlined,
                    size: 22.r, color: colors.neutral400),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  service.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.neutral900,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  service.categoryName,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: colors.neutral500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${service.effectivePrice.toStringAsFixed(0)} ${tr('home.currency')}',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: splashOrange,
                ),
              ),
              if (service.hasDiscount)
                Text(
                  service.price.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: colors.neutral400,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: colors.neutral400,
                  ),
                )
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time_rounded,
                        size: 11.r, color: colors.neutral400),
                    SizedBox(width: 2.w),
                    Text(
                      '${service.durationMinutes} ${tr('home.min')}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: colors.neutral400,
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

// ── Book Now bottom bar ───────────────────────────────────────────────────────

class _BookBar extends StatelessWidget {
  const _BookBar({required this.package, required this.colors});
  final PackageDetails package;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: colors.neutral50,
        border: Border(top: BorderSide(color: colors.neutral200)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tr('package_details.total'),
                style: TextStyle(fontSize: 11.sp, color: colors.neutral500),
              ),
              Row(
                children: [
                  Text(
                    '${package.effectivePrice.toStringAsFixed(0)} ${tr('home.currency')}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: splashOrange,
                    ),
                  ),
                  if (package.hasDiscount) ...[
                    SizedBox(width: 6.w),
                    Text(
                      package.price.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: colors.neutral400,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: colors.neutral400,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 48.h,
                decoration: BoxDecoration(
                  gradient: buttonGradient,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  tr('home.book_now'),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Loading shimmer ───────────────────────────────────────────────────────────

class _PackageShimmer extends StatelessWidget {
  const _PackageShimmer({required this.colors});
  final AppColors colors;

  Widget _box(double w, double h, double radius) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: colors.neutral200,
          borderRadius: BorderRadius.circular(radius),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: colors.neutral200,
      highlightColor: colors.neutral100,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero image (SliverAppBar expandedHeight: 240h) ──────────────
            Container(
              width: double.infinity,
              height: 240.h,
              color: colors.neutral200,
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── _PackageHeader: name + specialization chip ────────────
                  Row(
                    children: [
                      _box(160.w, 24.h, 6.r),
                      const Spacer(),
                      _box(56.w, 22.h, 999.r),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // ── _SalonRow: image + name + location + chevron ──────────
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: colors.neutral100,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: colors.neutral200),
                    ),
                    child: Row(
                      children: [
                        _box(46.r, 46.r, 8.r),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _box(100.w, 14.h, 4.r),
                              SizedBox(height: 6.h),
                              _box(140.w, 11.h, 4.r),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        _box(16.r, 16.r, 4.r),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // ── _Description: two text lines ─────────────────────────
                  _box(double.infinity, 13.h, 4.r),
                  SizedBox(height: 5.h),
                  _box(220.w, 13.h, 4.r),

                  SizedBox(height: 16.h),

                  // ── _PriceSummary card ────────────────────────────────────
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: colors.neutral100,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: colors.neutral200),
                    ),
                    child: Column(
                      children: [
                        // price row
                        Row(
                          children: [
                            _box(16.r, 16.r, 4.r),
                            SizedBox(width: 8.w),
                            _box(50.w, 12.h, 4.r),
                            const Spacer(),
                            _box(80.w, 16.h, 4.r),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        _box(double.infinity, 1.h, 0),
                        SizedBox(height: 14.h),
                        // savings row
                        Row(
                          children: [
                            _box(16.r, 16.r, 4.r),
                            SizedBox(width: 8.w),
                            _box(60.w, 12.h, 4.r),
                            const Spacer(),
                            _box(64.w, 13.h, 4.r),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        _box(double.infinity, 1.h, 0),
                        SizedBox(height: 14.h),
                        // duration row
                        Row(
                          children: [
                            _box(16.r, 16.r, 4.r),
                            SizedBox(width: 8.w),
                            _box(50.w, 12.h, 4.r),
                            const Spacer(),
                            _box(56.w, 13.h, 4.r),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        _box(double.infinity, 1.h, 0),
                        SizedBox(height: 14.h),
                        // services value row
                        Row(
                          children: [
                            _box(16.r, 16.r, 4.r),
                            SizedBox(width: 8.w),
                            _box(80.w, 12.h, 4.r),
                            const Spacer(),
                            _box(64.w, 13.h, 4.r),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // ── _SectionTitle: accent bar + title ─────────────────────
                  Row(
                    children: [
                      _box(4.w, 18.h, 999.r),
                      SizedBox(width: 8.w),
                      _box(140.w, 16.h, 4.r),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // ── _ServiceItem × 3 ──────────────────────────────────────
                  ...List.generate(3, (_) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: colors.neutral100,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: colors.neutral200),
                      ),
                      child: Row(
                        children: [
                          _box(56.r, 56.r, 8.r),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _box(100.w, 13.h, 4.r),
                                SizedBox(height: 5.h),
                                _box(70.w, 11.h, 4.r),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _box(56.w, 13.h, 4.r),
                              SizedBox(height: 4.h),
                              _box(40.w, 10.h, 4.r),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),

                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error state ───────────────────────────────────────────────────────────────

class _PackageError extends StatelessWidget {
  const _PackageError({required this.message, required this.colors});
  final String message;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: colors.neutral50),
      backgroundColor: colors.neutral50,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48.r,
              color: colors.neutral400,
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: colors.neutral600),
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () => context.read<PackageDetailsCubit>().load(
                context
                    .findAncestorWidgetOfExactType<PackageDetailsScreen>()!
                    .packageId,
              ),
              child: Text(tr('package_details.retry')),
            ),
          ],
        ),
      ),
    );
  }
}
