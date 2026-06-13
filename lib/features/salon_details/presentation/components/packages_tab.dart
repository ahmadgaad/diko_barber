import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/features/salon_details/domain/entities/package.dart';
import 'package:ronaq_barber/features/salon_details/domain/entities/salon_service.dart';
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

class _PackageTile extends StatefulWidget {
  const _PackageTile({
    required this.package,
    required this.isSelected,
    required this.colors,
  });

  final Package package;
  final bool isSelected;
  final AppColors colors;

  @override
  State<_PackageTile> createState() => _PackageTileState();
}

class _PackageTileState extends State<_PackageTile> {
  bool _expanded = false;

  void _toggleExpanded() {
    if (widget.package.services.isEmpty) return;
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final package = widget.package;
    final isSelected = widget.isSelected;
    final colors = widget.colors;
    final hasServices = package.services.isNotEmpty;

    return GestureDetector(
      onTap: _toggleExpanded,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(13.r)),
              child: SizedBox(
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
                  // Selection indicator — top-right corner (own tap target)
                  PositionedDirectional(
                    top: 10.h,
                    end: 10.w,
                    child: GestureDetector(
                      onTap: () => context
                          .read<SalonDetailsCubit>()
                          .togglePackageSelection(package.id),
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
                  ),
                ],
              ),
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
                  // Expand toggle + included services
                  if (hasServices) ...[
                    SizedBox(height: 8.h),
                    _ExpandToggle(
                      count: package.services.length,
                      expanded: _expanded,
                      colors: colors,
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      alignment: Alignment.topCenter,
                      curve: Curves.easeInOut,
                      child: _expanded
                          ? _IncludedServices(
                              services: package.services,
                              colors: colors,
                            )
                          : const SizedBox(width: double.infinity),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpandToggle extends StatelessWidget {
  const _ExpandToggle({
    required this.count,
    required this.expanded,
    required this.colors,
  });

  final int count;
  final bool expanded;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.layers_outlined, size: 14.r, color: splashOrange),
        SizedBox(width: 6.w),
        Text(
          tr('salon_details.services_included', namedArgs: {'count': '$count'}),
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: splashOrange,
          ),
        ),
        const Spacer(),
        AnimatedRotation(
          turns: expanded ? 0.5 : 0,
          duration: const Duration(milliseconds: 200),
          child: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20.r,
            color: splashOrange,
          ),
        ),
      ],
    );
  }
}

class _IncludedServices extends StatelessWidget {
  const _IncludedServices({required this.services, required this.colors});

  final List<SalonService> services;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        Divider(height: 1, color: colors.neutral200),
        SizedBox(height: 10.h),
        ...services.map(
          (s) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: CachedNetworkImage(
                    imageUrl: s.image,
                    width: 36.r,
                    height: 36.r,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => Container(
                      width: 36.r,
                      height: 36.r,
                      color: colors.neutral200,
                    ),
                    errorWidget: (_, _, _) => Container(
                      width: 36.r,
                      height: 36.r,
                      color: colors.neutral200,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.content_cut_rounded,
                        color: colors.neutral400,
                        size: 18.r,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    s.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.neutral900,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(Icons.timer_outlined, size: 12.r, color: colors.neutral500),
                SizedBox(width: 3.w),
                Text(
                  '${s.durationMinutes} ${tr('salon_details.min')}',
                  style: TextStyle(fontSize: 11.sp, color: colors.neutral500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
