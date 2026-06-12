import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart' hide Banner;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ronaq_barber/core/shared/domain/entities/banner.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/features/home/presentation/cubit/banners_cubit.dart';
import 'package:ronaq_barber/features/home/presentation/cubit/banners_state.dart';
import 'package:shimmer/shimmer.dart';

class BannersSection extends StatelessWidget {
  const BannersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannersCubit, BannersState>(
      builder: (context, state) => switch (state) {
        BannersLoading() => const _BannersShimmer(),
        BannersLoaded(:final banners) when banners.isEmpty =>
          const SizedBox.shrink(),
        BannersLoaded(:final banners) => _BannersCarousel(banners: banners),
        BannersError() => const SizedBox.shrink(),
      },
    );
  }
}

// ── Carousel ──────────────────────────────────────────────────────────────────

class _BannersCarousel extends StatefulWidget {
  const _BannersCarousel({required this.banners});
  final List<Banner> banners;

  @override
  State<_BannersCarousel> createState() => _BannersCarouselState();
}

class _BannersCarouselState extends State<_BannersCarousel> {
  int _currentIndex = 0;

  void _onBannerTap(BuildContext context, Banner banner) {
    switch (banner.campaignType) {
      case CampaignType.salon:
        context.push('/salon/${banner.salonId}');
      case CampaignType.service:
        // TODO: navigate to service detail screen — /service/${banner.targetId}
        context.push('/salon/${banner.salonId}');
      case CampaignType.package:
        // TODO: navigate to package detail screen — /package/${banner.targetId}
        context.push('/salon/${banner.salonId}');
      case CampaignType.unknown:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.banners.length;
    final appTextDir = Directionality.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [
          CarouselSlider.builder(
            itemCount: count,
            itemBuilder: (ctx, index, _) => _BannerCard(
              banner: widget.banners[index],
              textDirection: appTextDir,
              onTap: () => _onBannerTap(ctx, widget.banners[index]),
            ),
            options: CarouselOptions(
              height: 180.h,
              viewportFraction: 0.88,
              pageSnapping: true,
              enlargeCenterPage: true,
              enlargeFactor: 0.2,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 500),
              autoPlayCurve: Curves.easeInOut,
              onPageChanged: (index, _) =>
                  setState(() => _currentIndex = index),
            ),
          ),
          if (count > 1) ...[
            SizedBox(height: 10.h),
            _DotsIndicator(count: count, current: _currentIndex),
            SizedBox(height: 12.h),
          ],
        ],
      ),
    );
  }
}

// ── Banner card ───────────────────────────────────────────────────────────────

class _BannerCard extends StatelessWidget {
  const _BannerCard({
    required this.banner,
    required this.onTap,
    required this.textDirection,
  });
  final Banner banner;
  final VoidCallback onTap;
  final TextDirection textDirection;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              CachedNetworkImage(
                imageUrl: banner.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (_, _) => _CardShimmer(colors: colors),
                errorWidget: (_, _, _) => _CardError(colors: colors),
              ),
              // Bottom dark gradient
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.0, 0.65],
                    colors: [Color(0xCC000000), Colors.transparent],
                  ),
                ),
              ),
              // Title + description overlay
              Directionality(
                textDirection: textDirection,
                child: Positioned(
                  bottom: 12.h,
                  left: 14.w,
                  right: 14.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        banner.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      if (banner.description.isNotEmpty) ...[
                        SizedBox(height: 3.h),
                        Text(
                          banner.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              // Top badges row
              Directionality(
                textDirection: textDirection,
                child: PositionedDirectional(
                  top: 10.h,
                  start: 10.w,
                  end: 10.w,
                  child: Row(
                    
                    children: [
                      _CampaignTypeBadge(type: banner.campaignType),
                      if (banner.isFeatured) ...[
                        SizedBox(width: 6.w),
                        _FeaturedBadge(),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CampaignTypeBadge extends StatelessWidget {
  const _CampaignTypeBadge({required this.type});
  final CampaignType type;

  String _labelKey() => switch (type) {
        CampaignType.service => 'home.campaign_service',
        CampaignType.package => 'home.campaign_package',
        CampaignType.salon => 'home.campaign_salon',
        CampaignType.unknown => '',
      };

  @override
  Widget build(BuildContext context) {
    final key = _labelKey();
    if (key.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: splashOrange,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        tr(key),
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _FeaturedBadge extends StatelessWidget {
  const _FeaturedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
            color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded,
              size: 11.r, color: const Color(0xFFFFC107)),
          SizedBox(width: 3.w),
          Text(
            tr('home.featured'),
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardShimmer extends StatelessWidget {
  const _CardShimmer({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: colors.neutral200,
      highlightColor: colors.neutral100,
      child: Container(color: colors.neutral200),
    );
  }
}

class _CardError extends StatelessWidget {
  const _CardError({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.neutral200,
      child: Icon(
        Icons.broken_image_outlined,
        color: colors.neutral400,
        size: 32.r,
      ),
    );
  }
}

// ── Dots indicator ────────────────────────────────────────────────────────────

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.count, required this.current});
  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          width: isActive ? 20.w : 6.w,
          height: 6.h,
          decoration: BoxDecoration(
            color: isActive ? splashOrange : colors.neutral300,
            borderRadius: BorderRadius.circular(999.r),
          ),
        );
      }),
    );
  }
}

// ── Section shimmer ───────────────────────────────────────────────────────────

class _BannersShimmer extends StatelessWidget {
  const _BannersShimmer();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Shimmer.fromColors(
          baseColor: colors.neutral200,
          highlightColor: colors.neutral100,
          child: Column(
            children: [
              Container(
                height: 180.h,
                decoration: BoxDecoration(
                  color: colors.neutral200,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    width: i == 0 ? 20.w : 6.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: colors.neutral200,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  );
                }),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}
