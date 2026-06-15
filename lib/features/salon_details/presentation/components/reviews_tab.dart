import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/di/service_locator.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/features/salon_details/domain/entities/rating_stats.dart';
import 'package:zain/features/salon_details/domain/entities/review.dart';
import 'package:zain/features/salon_details/presentation/components/empty_tab.dart';
import 'package:zain/features/salon_details/presentation/cubit/salon_ratings_cubit.dart';
import 'package:zain/features/salon_details/presentation/cubit/salon_ratings_state.dart';
import 'package:shimmer/shimmer.dart';

class ReviewsTab extends StatelessWidget {
  const ReviewsTab({super.key, required this.salonId, required this.colors});

  final int salonId;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SalonRatingsCubit>()..load(salonId),
      child: _ReviewsView(colors: colors),
    );
  }
}

class _ReviewsView extends StatelessWidget {
  const _ReviewsView({required this.colors});

  final AppColors colors;

  bool _onScroll(BuildContext context, ScrollNotification n) {
    if (n.metrics.pixels >= n.metrics.maxScrollExtent - 300) {
      context.read<SalonRatingsCubit>().loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalonRatingsCubit, SalonRatingsState>(
      builder: (context, state) => switch (state) {
        SalonRatingsLoading() => _ReviewsShimmer(colors: colors),
        SalonRatingsError() => EmptyTab(
          icon: Icons.star_outline_rounded,
          message: tr('explore.error_body'),
          colors: colors,
        ),
        SalonRatingsLoaded() => state.ratings.isEmpty
            ? EmptyTab(
                icon: Icons.star_outline_rounded,
                message: tr('salon_details.reviews'),
                colors: colors,
              )
            : NotificationListener<ScrollNotification>(
                onNotification: (n) => _onScroll(context, n),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: _StatsBar(stats: state.stats, colors: colors),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                      sliver: SliverList.separated(
                        itemCount: state.ratings.length,
                        separatorBuilder: (_, _) => SizedBox(height: 10.h),
                        itemBuilder: (_, i) =>
                            _ReviewCard(review: state.ratings[i], colors: colors),
                      ),
                    ),
                    if (state.isLoadingMore)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: Center(
                            child: SizedBox(
                              width: 24.r,
                              height: 24.r,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colors.primary500,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      },
    );
  }
}

// ── Rating stats bar ─────────────────────────────────────────────────────────

class _StatsBar extends StatelessWidget {
  const _StatsBar({required this.stats, required this.colors});

  final RatingStats stats;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final total = stats.total;
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: Column(
        children: [
          _Bar(label: '5', count: stats.five, total: total, colors: colors),
          SizedBox(height: 6.h),
          _Bar(label: '4', count: stats.four, total: total, colors: colors),
          SizedBox(height: 6.h),
          _Bar(label: '3', count: stats.three, total: total, colors: colors),
          SizedBox(height: 6.h),
          _Bar(label: '2', count: stats.two, total: total, colors: colors),
          SizedBox(height: 6.h),
          _Bar(label: '1', count: stats.one, total: total, colors: colors),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.label,
    required this.count,
    required this.total,
    required this.colors,
  });

  final String label;
  final int count;
  final int total;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : count / total;
    return Row(
      children: [
        Icon(Icons.star_rounded, size: 14.r, color: const Color(0xFFFFC107)),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: colors.neutral700),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 6.h,
              backgroundColor: colors.neutral200,
              valueColor: const AlwaysStoppedAnimation(Color(0xFFFFC107)),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        SizedBox(
          width: 20.w,
          child: Text(
            '$count',
            style: TextStyle(fontSize: 12.sp, color: colors.neutral500),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

// ── Review card ───────────────────────────────────────────────────────────────

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review, required this.colors});

  final Review review;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: review.userAvatar,
                  width: 38.r,
                  height: 38.r,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(
                    width: 38.r,
                    height: 38.r,
                    color: colors.neutral200,
                  ),
                  errorWidget: (_, _, _) => Container(
                    width: 38.r,
                    height: 38.r,
                    color: colors.neutral200,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.person_outline,
                      color: colors.neutral400,
                      size: 20.r,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.neutral900,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      review.createdAt,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: colors.neutral400,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < review.rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 14.r,
                    color: const Color(0xFFFFC107),
                  );
                }),
              ),
            ],
          ),
          if (review.comment.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Text(
              review.comment,
              style: TextStyle(
                fontSize: 13.sp,
                color: colors.neutral700,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Shimmer ───────────────────────────────────────────────────────────────────

class _ReviewsShimmer extends StatelessWidget {
  const _ReviewsShimmer({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: colors.neutral200,
      highlightColor: colors.neutral100,
      child: ListView.separated(
        padding: EdgeInsets.all(16.w),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (_, _) => SizedBox(height: 10.h),
        itemBuilder: (_, _) => Container(
          height: 100.h,
          decoration: BoxDecoration(
            color: colors.neutral200,
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
      ),
    );
  }
}
