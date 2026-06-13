import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/di/service_locator.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/features/salon_details/domain/entities/gallery_image.dart';
import 'package:ronaq_barber/features/salon_details/presentation/components/empty_tab.dart';
import 'package:ronaq_barber/features/salon_details/presentation/cubit/salon_gallery_cubit.dart';
import 'package:ronaq_barber/features/salon_details/presentation/cubit/salon_gallery_state.dart';
import 'package:shimmer/shimmer.dart';

class GalleryTab extends StatelessWidget {
  const GalleryTab({super.key, required this.salonId, required this.colors});

  final int salonId;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SalonGalleryCubit>()..load(salonId),
      child: _GalleryView(colors: colors),
    );
  }
}

class _GalleryView extends StatelessWidget {
  const _GalleryView({required this.colors});

  final AppColors colors;

  bool _onScroll(BuildContext context, ScrollNotification n) {
    if (n.metrics.pixels >= n.metrics.maxScrollExtent - 300) {
      context.read<SalonGalleryCubit>().loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalonGalleryCubit, SalonGalleryState>(
      builder: (context, state) => switch (state) {
        SalonGalleryLoading() => _GalleryShimmer(colors: colors),
        SalonGalleryError() => EmptyTab(
          icon: Icons.broken_image_outlined,
          message: tr('explore.error_body'),
          colors: colors,
        ),
        SalonGalleryLoaded(:final images) when images.isEmpty => EmptyTab(
          icon: Icons.image_outlined,
          message: tr('salon_details.no_gallery'),
          colors: colors,
        ),
        SalonGalleryLoaded() => NotificationListener<ScrollNotification>(
          onNotification: (n) => _onScroll(context, n),
          child: GridView.builder(
            padding: EdgeInsets.all(12.w),
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 6.w,
              mainAxisSpacing: 6.h,
            ),
            itemCount: state.images.length + (state.isLoadingMore ? 3 : 0),
            itemBuilder: (context, i) {
              if (i >= state.images.length) {
                return _GalleryBox(colors: colors);
              }
              return _GalleryThumb(image: state.images[i], colors: colors);
            },
          ),
        ),
      },
    );
  }
}

class _GalleryThumb extends StatelessWidget {
  const _GalleryThumb({required this.image, required this.colors});

  final GalleryImage image;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPreview(context, image),
      child: Hero(
        tag: 'gallery_${image.id}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: CachedNetworkImage(
            imageUrl: image.url,
            fit: BoxFit.cover,
            placeholder: (_, _) => Container(color: colors.neutral200),
            errorWidget: (_, _, _) => Container(
              color: colors.neutral200,
              alignment: Alignment.center,
              child: Icon(
                Icons.image_outlined,
                color: colors.neutral400,
                size: 24.r,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _openPreview(BuildContext context, GalleryImage image) {
  Navigator.of(context).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, animation, _) => FadeTransition(
        opacity: animation,
        child: _GalleryPreview(image: image),
      ),
    ),
  );
}

class _GalleryPreview extends StatelessWidget {
  const _GalleryPreview({required this.image});

  final GalleryImage image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Tap anywhere to dismiss
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              behavior: HitTestBehavior.opaque,
            ),
          ),
          Center(
            child: Hero(
              tag: 'gallery_${image.id}',
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: CachedNetworkImage(
                  imageUrl: image.url,
                  fit: BoxFit.contain,
                  placeholder: (_, _) => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  errorWidget: (_, _, _) => Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white54,
                    size: 48.r,
                  ),
                ),
              ),
            ),
          ),
          // Title
          if (image.title.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: Text(
                  image.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          // Close button
          PositionedDirectional(
            top: MediaQuery.paddingOf(context).top + 8.h,
            end: 12.w,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close_rounded, color: Colors.white, size: 20.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GalleryShimmer extends StatelessWidget {
  const _GalleryShimmer({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: colors.neutral200,
      highlightColor: colors.neutral100,
      child: GridView.builder(
        padding: EdgeInsets.all(12.w),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 6.w,
          mainAxisSpacing: 6.h,
        ),
        itemCount: 12,
        itemBuilder: (_, _) => _GalleryBox(colors: colors),
      ),
    );
  }
}

class _GalleryBox extends StatelessWidget {
  const _GalleryBox({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.neutral200,
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }
}
