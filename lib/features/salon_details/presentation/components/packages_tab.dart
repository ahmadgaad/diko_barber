import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/features/salon_details/domain/entities/package.dart';
import 'package:ronaq_barber/features/salon_details/presentation/cubit/salon_details_cubit.dart';

class PackagesTab extends StatelessWidget {
  const PackagesTab({
    super.key,
    required this.packages,
    required this.selectedIds,
    required this.colors,
  });

  final List<Package> packages;
  final Set<int> selectedIds;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      physics: const BouncingScrollPhysics(),
      itemCount: packages.length,
      separatorBuilder: (_, _) => SizedBox(height: 10.h),
      itemBuilder: (context, i) => _PackageTile(
        package: packages[i],
        isSelected: selectedIds.contains(packages[i].id),
        colors: colors,
      ),
    );
  }
}

class _PackageTile extends StatelessWidget {
  const _PackageTile({
    required this.package,
    required this.isSelected,
    required this.colors,
  });

  final Package package;
  final bool isSelected;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.read<SalonDetailsCubit>().togglePackageSelection(package.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: colors.neutral100,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? splashOrange : colors.neutral200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 120.h,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: package.image,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => Container(color: colors.neutral200),
                    errorWidget: (_, _, _) => Container(
                      color: colors.neutral200,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.spa_outlined,
                        color: colors.neutral400,
                        size: 32.r,
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
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
                            horizontal: 10.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: splashOrange,
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: Text(
                            '${package.price.toInt()} ${tr('home.currency')}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Selection indicator — top-right corner
                  PositionedDirectional(
                    top: 10.h,
                    end: 10.w,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 24.r,
                      height: 24.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? splashOrange
                            : Colors.black.withValues(alpha: 0.35),
                        border: Border.all(
                          color: isSelected ? splashOrange : Colors.white54,
                          width: 1.5,
                        ),
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check_rounded,
                              size: 14.r,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.description,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: colors.neutral600,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 13.r,
                        color: const Color(0xFFFFC107),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        package.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: colors.neutral700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
