import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/features/salon_details/domain/entities/review.dart';

class ReviewsTab extends StatelessWidget {
  const ReviewsTab({super.key, required this.reviews, required this.colors});

  final List<Review> reviews;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      physics: const BouncingScrollPhysics(),
      itemCount: reviews.length,
      separatorBuilder: (_, _) => SizedBox(height: 10.h),
      itemBuilder: (context, i) =>
          _ReviewCard(review: reviews[i], colors: colors),
    );
  }
}

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
                      DateFormat(
                        'dd MMM yyyy',
                        context.locale.languageCode,
                      ).format(review.createdAt),
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
                    i < review.rating.round()
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 14.r,
                    color: const Color(0xFFFFC107),
                  );
                }),
              ),
            ],
          ),
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
      ),
    );
  }
}
