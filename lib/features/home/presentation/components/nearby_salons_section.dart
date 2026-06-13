import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ronaq_barber/core/shared/domain/entities/salon.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/core/widgets/app_bottom_nav_bar.dart';
import 'package:ronaq_barber/features/home/presentation/components/section_header.dart';
import 'package:ronaq_barber/features/home/presentation/cubit/salons_cubit.dart';
import 'package:ronaq_barber/features/home/presentation/cubit/salons_state.dart';
import 'package:ronaq_barber/features/home/presentation/screens/home_view.dart';
import 'package:shimmer/shimmer.dart';

class NearbySalonsSection extends StatelessWidget {
  const NearbySalonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocBuilder<SalonsCubit, SalonsState>(
      builder: (context, state) => switch (state) {
        SalonsLoading() => _SalonsShimmer(colors: colors),
        SalonsLoaded(:final salons) when salons.isEmpty =>
          const SizedBox.shrink(),
        SalonsLoaded(:final salons, :final isLoadingMore) => _SalonsList(
          salons: salons,
          isLoadingMore: isLoadingMore,
          colors: colors,
        ),
        SalonsError() => const SizedBox.shrink(),
      },
    );
  }
}

// ── Loaded list ───────────────────────────────────────────────────────────────

class _SalonsList extends StatelessWidget {
  const _SalonsList({
    required this.salons,
    required this.isLoadingMore,
    required this.colors,
  });
  final List<Salon> salons;
  final bool isLoadingMore;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SectionHeader(
            titleKey: 'home.nearby_salons',
            colors: colors,
            onSeeMore: () => HomeScope.of(context).onSwitchTab(HomeTab.explore),
          ),
        ),
        SizedBox(height: 12.h),
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification &&
                notification.metrics.pixels >=
                    notification.metrics.maxScrollExtent - 120) {
              context.read<SalonsCubit>().loadMore();
            }
            return false;
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...salons.map(
                  (salon) => Padding(
                    padding: EdgeInsetsDirectional.only(end: 12.w),
                    child: GestureDetector(
                      onTap: () => context.push('/salon/${salon.id}'),
                      child: _SalonCard(salon: salon, colors: colors),
                    ),
                  ),
                ),
                if (isLoadingMore) _ShimmerCards(colors: colors),
              ],
            ),
          ),
        ),
        SizedBox(height: 14.h),
      ],
    );
  }
}

class _SalonCard extends StatelessWidget {
  const _SalonCard({required this.salon, required this.colors});
  final Salon salon;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280.w,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SalonImage(salon: salon, colors: colors),
          if (salon.categories.isNotEmpty)
            _CategoryBar(categories: salon.categories),
        ],
      ),
    );
  }
}

class _SalonImage extends StatelessWidget {
  const _SalonImage({required this.salon, required this.colors});
  final Salon salon;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: salon.image,
          width: 280.w,
          height: 140.h,
          fit: BoxFit.cover,
          placeholder: (_, _) =>
              Container(width: 280.w, height: 140.h, color: colors.neutral300),
          errorWidget: (_, _, _) => Container(
            width: 280.w,
            height: 140.h,
            color: colors.neutral300,
            alignment: Alignment.center,
            child: Icon(
              Icons.store_outlined,
              color: colors.neutral400,
              size: 40.r,
            ),
          ),
        ),
        // Bottom gradient overlay
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 90.h,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.75),
                ],
              ),
            ),
          ),
        ),
        PositionedDirectional(
          top: 10.h,
          start: 10.w,
          child: _FavoriteButton(
            isFavorite: salon.isFavorite,
            colors: colors,
            onTap: () => context.read<SalonsCubit>().toggleFavorite(salon.id),
          ),
        ),
        // Top-right: distance badge
        if (salon.distance != null)
          PositionedDirectional(
            top: 10.h,
            end: 10.w,
            child: _DistanceBadge(distance: salon.distance!.formatted),
          ),
        // Bottom-left: rating
        PositionedDirectional(
          bottom: 10.h,
          start: 10.w,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star_rounded,
                color: const Color(0xFFFFC107),
                size: 16.r,
              ),
              SizedBox(width: 4.w),
              Text(
                salon.averageRating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        // Bottom-right: salon name
        PositionedDirectional(
          bottom: 10.h,
          end: 10.w,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 160.w),
            child: Text(
              salon.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DistanceBadge extends StatelessWidget {
  const _DistanceBadge({required this.distance});
  final String distance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        distance,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({
    required this.isFavorite,
    required this.colors,
    required this.onTap,
  });
  final bool isFavorite;
  final AppColors colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28.r,
        height: 28.r,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: isFavorite ? Colors.red : Colors.white,
          size: 16.r,
        ),
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({required this.categories});
  final List<String> categories;

  static const int _maxVisible = 4;

  @override
  Widget build(BuildContext context) {
    final overflow = categories.length - _maxVisible;
    final visible = categories.take(_maxVisible).toList();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      color: const Color(0xFF2A2A2A),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...visible.map(
              (cat) => Padding(
                padding: EdgeInsetsDirectional.only(end: 6.w),
                child: _Chip(label: cat),
              ),
            ),
            if (overflow > 0) _Chip(label: '+$overflow'),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0xFF3D3D3D),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ── Shared shimmer card skeleton ──────────────────────────────────────────────

class _SalonCardShimmer extends StatelessWidget {
  const _SalonCardShimmer({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280.w,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image area with overlay placeholders
          SizedBox(
            width: 280.w,
            height: 140.h,
            child: Stack(
              children: [
                // Image placeholder
                Container(
                  width: 280.w,
                  height: 140.h,
                  color: colors.neutral300,
                ),
                // Top-left: favorite circle
                PositionedDirectional(
                  top: 10.h,
                  start: 10.w,
                  child: Container(
                    width: 28.r,
                    height: 28.r,
                    decoration: BoxDecoration(
                      color: colors.neutral400,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Top-right: distance badge
                PositionedDirectional(
                  top: 10.h,
                  end: 10.w,
                  child: Container(
                    width: 72.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: colors.neutral400,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                ),
                // Bottom-left: rating pill
                PositionedDirectional(
                  bottom: 10.h,
                  start: 10.w,
                  child: Container(
                    width: 44.w,
                    height: 18.h,
                    decoration: BoxDecoration(
                      color: colors.neutral400,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                ),
                // Bottom-right: name bar
                PositionedDirectional(
                  bottom: 10.h,
                  end: 10.w,
                  child: Container(
                    width: 110.w,
                    height: 18.h,
                    decoration: BoxDecoration(
                      color: colors.neutral400,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Category bar
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            color: const Color(0xFF2A2A2A),
            child: Row(
              children: List.generate(
                4,
                (_) => Padding(
                  padding: EdgeInsetsDirectional.only(end: 6.w),
                  child: Container(
                    width: 56.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3D3D3D),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
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

// ── Load-more shimmer cards (appended to the horizontal row) ─────────────────

class _ShimmerCards extends StatelessWidget {
  const _ShimmerCards({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: colors.neutral300,
      highlightColor: colors.neutral200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          2,
          (_) => Padding(
            padding: EdgeInsetsDirectional.only(end: 12.w),
            child: _SalonCardShimmer(colors: colors),
          ),
        ),
      ),
    );
  }
}

// ── Initial loading shimmer ───────────────────────────────────────────────────

class _SalonsShimmer extends StatelessWidget {
  const _SalonsShimmer({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Shimmer.fromColors(
            baseColor: colors.neutral200,
            highlightColor: colors.neutral100,
            child: Row(
              children: [
                Container(
                  width: 6.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                    color: colors.neutral200,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  width: 120.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                    color: colors.neutral200,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Shimmer.fromColors(
          baseColor: colors.neutral300,
          highlightColor: colors.neutral200,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: List.generate(
                3,
                (_) => Padding(
                  padding: EdgeInsetsDirectional.only(end: 12.w),
                  child: _SalonCardShimmer(colors: colors),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 14.h),
      ],
    );
  }
}
