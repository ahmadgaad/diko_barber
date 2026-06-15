import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/features/salon_details/domain/entities/salon_service.dart';
import 'package:zain/features/salon_details/presentation/cubit/salon_details_cubit.dart';

class ServicesTab extends StatelessWidget {
  const ServicesTab({
    super.key,
    required this.services,
    required this.selectedIds,
    required this.colors,
  });

  final List<SalonService> services;
  final Set<int> selectedIds;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      physics: const BouncingScrollPhysics(),
      itemCount: services.length,
      separatorBuilder: (_, _) => SizedBox(height: 10.h),
      itemBuilder: (context, i) => _ServiceTile(
        service: services[i],
        isSelected: selectedIds.contains(services[i].id),
        colors: colors,
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.service,
    required this.isSelected,
    required this.colors,
  });

  final SalonService service;
  final bool isSelected;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.read<SalonDetailsCubit>().toggleServiceSelection(service.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: colors.neutral100,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? splashOrange : colors.neutral200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(15.r),
                  bottomStart: Radius.circular(15.r),
                ),
                child: CachedNetworkImage(
                  imageUrl: service.image,
                  width: 100.w,
                  height: 110.h,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(
                    width: 100.w,
                    height: 110.h,
                    color: colors.neutral200,
                  ),
                  errorWidget: (_, _, _) => Container(
                    width: 100.w,
                    height: 110.h,
                    color: colors.neutral200,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.content_cut_rounded,
                      color: colors.neutral400,
                      size: 28.r,
                    ),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Selection check + name
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              service.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.neutral900,
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 22.r,
                            height: 22.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? splashOrange
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? splashOrange
                                    : colors.neutral400,
                                width: 1.5,
                              ),
                            ),
                            child: isSelected
                                ? Icon(
                                    Icons.check_rounded,
                                    size: 12.r,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ],
                      ),
                      // Description
                      Text(
                        service.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: colors.neutral500,
                          height: 1.4,
                        ),
                      ),
                      // Bottom row: meta chips + price
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: colors.neutral200,
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.timer_outlined,
                                  size: 11.r,
                                  color: colors.neutral500,
                                ),
                                SizedBox(width: 3.w),
                                Text(
                                  '${service.durationMinutes} ${tr('salon_details.min')}',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: colors.neutral600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF8E7),
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  size: 11.r,
                                  color: const Color(0xFFFFC107),
                                ),
                                SizedBox(width: 3.w),
                                Text(
                                  service.rating.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF6B4F00),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${service.price.toInt()} ${tr('home.currency')}',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w800,
                              color: splashOrange,
                            ),
                          ),
                        ],
                      ),
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
