import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ronaq_barber/core/shared/domain/entities/salon.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/features/home/presentation/components/section_header.dart';
import 'package:ronaq_barber/features/home/presentation/cubit/salons_cubit.dart';
import 'package:ronaq_barber/features/home/presentation/cubit/salons_state.dart';
import 'package:shimmer/shimmer.dart';

class NearbySalonsSection extends StatelessWidget {
  const NearbySalonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocBuilder<SalonsCubit, SalonsState>(
      builder: (context, state) => switch (state) {
        SalonsLoading() => _SalonsShimmer(colors: colors),
        SalonsLoaded(:final salons) when salons.isEmpty => const SizedBox.shrink(),
        SalonsLoaded(:final salons) => _SalonsList(salons: salons, colors: colors),
        SalonsError() => const SizedBox.shrink(),
      },
    );
  }
}

// ── Loaded list ───────────────────────────────────────────────────────────────

class _SalonsList extends StatelessWidget {
  const _SalonsList({required this.salons, required this.colors});
  final List<Salon> salons;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SectionHeader(titleKey: 'home.nearby_salons', colors: colors),
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: salons.map((salon) {
              return Padding(
                padding: EdgeInsetsDirectional.only(end: 12.w),
                child: GestureDetector(
                  onTap: () => context.push('/salon/${salon.id}'),
                  child: _SalonCard(salon: salon, colors: colors),
                ),
              );
            }).toList(),
          ),
        ),
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
    return SizedBox(
      width: 160.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SalonImage(salon: salon, colors: colors),
          SizedBox(height: 8.h),
          Text(
            salon.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: colors.neutral900,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(Icons.star_rounded, color: const Color(0xFFFFC107), size: 14.r),
              SizedBox(width: 2.w),
              Text(
                salon.rating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: colors.neutral700,
                ),
              ),
              SizedBox(width: 6.w),
              Container(
                width: 3.w,
                height: 3.h,
                decoration: BoxDecoration(
                  color: colors.neutral400,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                '${salon.distance.toStringAsFixed(1)} ${tr('home.km')}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: colors.neutral700,
                ),
              ),
            ],
          ),
          if (salon.categories.isNotEmpty) ...[
            SizedBox(height: 6.h),
            _CategoryChips(categories: salon.categories, colors: colors),
          ],
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
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: CachedNetworkImage(
            imageUrl: salon.logo,
            width: 160.w,
            height: 110.h,
            fit: BoxFit.cover,
            placeholder: (_, _) => Container(
              width: 160.w,
              height: 110.h,
              decoration: BoxDecoration(
                color: colors.neutral200,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            errorWidget: (_, _, _) => Container(
              width: 160.w,
              height: 110.h,
              decoration: BoxDecoration(
                color: colors.neutral200,
                borderRadius: BorderRadius.circular(12.r),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.store_outlined, color: colors.neutral400, size: 32.r),
            ),
          ),
        ),
        PositionedDirectional(
          top: 8.h,
          end: 8.w,
          child: _FavoriteButton(isFavorite: salon.isFavorite, colors: colors),
        ),
        if (salon.isOpen)
          PositionedDirectional(
            top: 8.h,
            start: 8.w,
            child: _OpenBadge(colors: colors),
          ),
      ],
    );
  }
}

class _OpenBadge extends StatelessWidget {
  const _OpenBadge({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: colors.success500,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        tr('home.open'),
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.isFavorite, required this.colors});
  final bool isFavorite;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28.r,
      height: 28.r,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        color: isFavorite ? splashOrange : Colors.white,
        size: 16.r,
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({required this.categories, required this.colors});
  final List<String> categories;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final visible = categories.take(2).toList();
    return Wrap(
      spacing: 4.w,
      children: visible.map((cat) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: colors.neutral100,
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(color: colors.neutral200),
          ),
          child: Text(
            cat,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: colors.neutral700,
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Shimmer ───────────────────────────────────────────────────────────────────

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
          baseColor: colors.neutral200,
          highlightColor: colors.neutral100,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: List.generate(3, (i) {
                return Padding(
                  padding: EdgeInsetsDirectional.only(end: 12.w),
                  child: SizedBox(
                    width: 160.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 160.w,
                          height: 110.h,
                          decoration: BoxDecoration(
                            color: colors.neutral200,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          width: 100.w,
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: colors.neutral200,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          width: 80.w,
                          height: 12.h,
                          decoration: BoxDecoration(
                            color: colors.neutral200,
                            borderRadius: BorderRadius.circular(4.r),
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
    );
  }
}
