import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/core/widgets/app_gradient_button.dart';
import 'package:zain/features/claim_coupon/domain/entities/coupon_eligible_package.dart';
import 'package:zain/features/claim_coupon/domain/entities/coupon_eligible_service.dart';
import 'package:zain/features/claim_coupon/presentation/cubit/claim_coupon_cubit.dart';
import 'package:zain/features/claim_coupon/presentation/cubit/claim_coupon_state.dart';

class ClaimCouponView extends StatelessWidget {
  const ClaimCouponView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocBuilder<ClaimCouponCubit, ClaimCouponState>(
      builder: (context, state) => switch (state) {
        ClaimCouponLoading() => _LoadingScaffold(colors: colors),
        ClaimCouponError(:final message) =>
          _ErrorScaffold(message: message, colors: colors),
        ClaimCouponData() => _DataScaffold(state: state, colors: colors),
      },
    );
  }
}

// ── Data scaffold ─────────────────────────────────────────────────────────────

class _DataScaffold extends StatelessWidget {
  const _DataScaffold({required this.state, required this.colors});

  final ClaimCouponData state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.neutral50,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopBar(state: state, colors: colors),
            Expanded(child: _ItemsContent(state: state, colors: colors)),
          ],
        ),
      ),
      bottomNavigationBar: _BottomActionBar(state: state, colors: colors),
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({required this.state, required this.colors});

  final ClaimCouponData state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.neutral50,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: colors.neutral100,
                shape: BoxShape.circle,
                border: Border.all(color: colors.neutral200),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16.r,
                color: colors.neutral900,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  tr('claim_coupon.title'),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.neutral900,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  state.salonName,
                  style: TextStyle(fontSize: 12.sp, color: colors.neutral500),
                ),
              ],
            ),
          ),
          SizedBox(width: 38.r),
        ],
      ),
    );
  }
}

// ── Items content ─────────────────────────────────────────────────────────────

class _ItemsContent extends StatelessWidget {
  const _ItemsContent({required this.state, required this.colors});

  final ClaimCouponData state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    if (!state.hasItems) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inbox_outlined, size: 56.r, color: colors.neutral300),
              SizedBox(height: 12.h),
              Text(
                tr('claim_coupon.no_items'),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: colors.neutral500),
              ),
            ],
          ),
        ),
      );
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 4.h),
          sliver: SliverToBoxAdapter(
            child: Text(
              tr('claim_coupon.select_item'),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: colors.neutral900,
              ),
            ),
          ),
        ),

        // ── Services section ─────────────────────────────────────────────────
        if (state.services.isNotEmpty) ...[
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 10.h),
            sliver: SliverToBoxAdapter(
              child: _SectionHeader(
                label: tr('claim_coupon.services'),
                count: state.selectedServiceIds.length,
                colors: colors,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverList.separated(
              itemCount: state.services.length,
              separatorBuilder: (_, _) => SizedBox(height: 10.h),
              itemBuilder: (context, i) {
                final service = state.services[i];
                return _ServiceCard(
                  service: service,
                  isSelected: state.selectedServiceIds.contains(service.id),
                  colors: colors,
                );
              },
            ),
          ),
        ],

        // ── Packages section ─────────────────────────────────────────────────
        if (state.packages.isNotEmpty) ...[
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              16.w,
              state.services.isNotEmpty ? 24.h : 16.h,
              16.w,
              10.h,
            ),
            sliver: SliverToBoxAdapter(
              child: _SectionHeader(
                label: tr('claim_coupon.packages'),
                count: state.selectedPackageIds.length,
                colors: colors,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverList.separated(
              itemCount: state.packages.length,
              separatorBuilder: (_, _) => SizedBox(height: 10.h),
              itemBuilder: (context, i) {
                final package = state.packages[i];
                return _PackageCard(
                  package: package,
                  isSelected: state.selectedPackageIds.contains(package.id),
                  colors: colors,
                );
              },
            ),
          ),
        ],

        SliverPadding(padding: EdgeInsets.only(bottom: 24.h)),
      ],
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.label,
    required this.count,
    required this.colors,
  });

  final String label;
  final int count;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: colors.neutral900,
          ),
        ),
        if (count > 0) ...[
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: splashOrange,
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ── Service card ──────────────────────────────────────────────────────────────

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.service,
    required this.isSelected,
    required this.colors,
  });

  final CouponEligibleService service;
  final bool isSelected;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.read<ClaimCouponCubit>().toggleService(service.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: colors.neutral100,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? splashOrange : colors.neutral200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: CachedNetworkImage(
                imageUrl: service.image,
                width: 70.r,
                height: 70.r,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                  width: 70.r,
                  height: 70.r,
                  color: colors.neutral200,
                ),
                errorWidget: (_, _, _) => Container(
                  width: 70.r,
                  height: 70.r,
                  color: colors.neutral200,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.content_cut_rounded,
                    color: colors.neutral400,
                    size: 24.r,
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
                    service.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
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
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 13.r,
                        color: colors.neutral400,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        '${service.durationMinutes} ${tr('salon_details.min')}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: colors.neutral500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${service.effectivePrice.toInt()} ${tr('home.currency')}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: splashOrange,
                  ),
                ),
                SizedBox(height: 6.h),
                _CheckBox(isSelected: isSelected, colors: colors),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Package card ──────────────────────────────────────────────────────────────

class _PackageCard extends StatelessWidget {
  const _PackageCard({
    required this.package,
    required this.isSelected,
    required this.colors,
  });

  final CouponEligiblePackage package;
  final bool isSelected;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.read<ClaimCouponCubit>().togglePackage(package.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: colors.neutral100,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? splashOrange : colors.neutral200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: CachedNetworkImage(
                imageUrl: package.image,
                width: 70.r,
                height: 70.r,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                  width: 70.r,
                  height: 70.r,
                  color: colors.neutral200,
                ),
                errorWidget: (_, _, _) => Container(
                  width: 70.r,
                  height: 70.r,
                  color: colors.neutral200,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.inventory_2_outlined,
                    color: colors.neutral400,
                    size: 24.r,
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
                    package.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.neutral900,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  if (package.specializationName != null)
                    Text(
                      package.specializationName!,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: colors.neutral500,
                      ),
                    ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 13.r,
                        color: colors.neutral400,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        '${package.durationMinutes} ${tr('salon_details.min')}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: colors.neutral500,
                        ),
                      ),
                      if (package.savings != null && package.savings! > 0) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: colors.success600.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            tr(
                              'claim_coupon.save',
                              namedArgs: {
                                'amount': '${package.savings!.toInt()}',
                              },
                            ),
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.success600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${package.effectivePrice.toInt()} ${tr('home.currency')}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: splashOrange,
                  ),
                ),
                SizedBox(height: 6.h),
                _CheckBox(isSelected: isSelected, colors: colors),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Checkbox ──────────────────────────────────────────────────────────────────

class _CheckBox extends StatelessWidget {
  const _CheckBox({required this.isSelected, required this.colors});

  final bool isSelected;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 22.r,
      height: 22.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        color: isSelected ? splashOrange : Colors.transparent,
        border: Border.all(
          color: isSelected ? splashOrange : colors.neutral300,
          width: 2,
        ),
      ),
      child: isSelected
          ? Icon(Icons.check_rounded, size: 13.r, color: Colors.white)
          : null,
    );
  }
}

// ── Bottom action bar ─────────────────────────────────────────────────────────

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({required this.state, required this.colors});

  final ClaimCouponData state;
  final AppColors colors;

  int get _totalSelected =>
      state.selectedServiceIds.length + state.selectedPackageIds.length;

  @override
  Widget build(BuildContext context) {
    final label = state.canProceed
        ? tr('claim_coupon.next_with_count', namedArgs: {'count': '$_totalSelected'})
        : tr('claim_coupon.next');

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
      decoration: BoxDecoration(
        color: colors.neutral50,
        border: Border(top: BorderSide(color: colors.neutral200)),
      ),
      child: AppGradientButton(
        label: label,
        enabled: state.canProceed,
        onTap: () {
          if (!state.canProceed) return;
          // Next steps will be determined later
        },
      ),
    );
  }
}

// ── Loading scaffold ──────────────────────────────────────────────────────────

class _LoadingScaffold extends StatelessWidget {
  const _LoadingScaffold({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.neutral50,
      body: Shimmer.fromColors(
        baseColor: colors.neutral200,
        highlightColor: colors.neutral100,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 160.w,
                  height: 22.h,
                  color: colors.neutral200,
                ),
                SizedBox(height: 20.h),
                ...List.generate(
                  4,
                  (_) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Container(
                      height: 94.h,
                      decoration: BoxDecoration(
                        color: colors.neutral200,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Error scaffold ────────────────────────────────────────────────────────────

class _ErrorScaffold extends StatelessWidget {
  const _ErrorScaffold({required this.message, required this.colors});

  final String message;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.neutral50,
      appBar: AppBar(
        backgroundColor: colors.neutral50,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colors.neutral900,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 56.r,
              color: colors.neutral300,
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: colors.neutral600),
            ),
          ],
        ),
      ),
    );
  }
}
