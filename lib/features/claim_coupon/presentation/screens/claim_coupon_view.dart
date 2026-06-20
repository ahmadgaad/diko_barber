import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zain/core/router/app_routes.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/core/widgets/app_gradient_button.dart';
import 'package:zain/core/widgets/app_snack_bar.dart';
import 'package:zain/features/book_appointment/domain/entities/staff_member.dart';
import 'package:zain/features/claim_coupon/domain/entities/coupon_eligible_package.dart';
import 'package:zain/features/claim_coupon/domain/entities/coupon_eligible_service.dart';
import 'package:zain/features/claim_coupon/presentation/cubit/claim_coupon_cubit.dart';
import 'package:zain/features/claim_coupon/presentation/cubit/claim_coupon_state.dart';

class ClaimCouponView extends StatelessWidget {
  const ClaimCouponView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocConsumer<ClaimCouponCubit, ClaimCouponState>(
      listenWhen: (prev, curr) {
        if (curr is ClaimCouponSuccess) return true;
        if (prev is ClaimCouponData && curr is ClaimCouponData) {
          return curr.apiError != null && curr.apiError != prev.apiError;
        }
        return false;
      },
      listener: (context, state) {
        if (state is ClaimCouponSuccess) {
          context.pushReplacement(
            AppRoutes.checkout,
            extra: state.appointment,
          );
        }
        if (state is ClaimCouponData && state.apiError != null) {
          AppSnackBar.show(
            context,
            message: state.apiError!,
            type: SnackBarType.error,
          );
        }
      },
      buildWhen: (_, curr) => curr is! ClaimCouponSuccess,
      builder: (context, state) => switch (state) {
        ClaimCouponLoading() => _LoadingScaffold(colors: colors),
        ClaimCouponError(:final message) =>
          _ErrorScaffold(message: message, colors: colors),
        ClaimCouponData() => _DataScaffold(state: state, colors: colors),
        ClaimCouponSuccess() => const SizedBox.shrink(),
      },
    );
  }
}

// ── Data scaffold ─────────────────────────────────────────────────────────────

class _DataScaffold extends StatefulWidget {
  const _DataScaffold({required this.state, required this.colors});

  final ClaimCouponData state;
  final AppColors colors;

  @override
  State<_DataScaffold> createState() => _DataScaffoldState();
}

class _DataScaffoldState extends State<_DataScaffold>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final colors = widget.colors;
    return Scaffold(
      backgroundColor: colors.neutral50,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopBar(state: state, colors: colors),
            if (state.step == 1) ...[
              _TabBar(
                tabController: _tabController,
                state: state,
                colors: colors,
              ),
            ],
            Expanded(
              child: state.step == 1
                  ? _ItemsContent(
                      tabController: _tabController,
                      state: state,
                      colors: colors,
                    )
                  : _ScheduleContent(state: state, colors: colors),
            ),
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
            onTap: () {
              if (state.step > 1) {
                context.read<ClaimCouponCubit>().goToStep(state.step - 1);
              } else {
                Navigator.of(context).pop();
              }
            },
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
                  state.step == 1
                      ? tr('claim_coupon.title')
                      : tr('claim_coupon.schedule_title'),
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

// ── Step 1: Tab bar ───────────────────────────────────────────────────────────

class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.tabController,
    required this.state,
    required this.colors,
  });

  final TabController tabController;
  final ClaimCouponData state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.neutral50,
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 0),
      child: TabBar(
        controller: tabController,
        indicatorColor: splashOrange,
        indicatorWeight: 2.5,
        labelColor: splashOrange,
        unselectedLabelColor: colors.neutral500,
        labelStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
        unselectedLabelStyle:
            TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
        tabs: [
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(tr('claim_coupon.services')),
                if (state.selectedServiceIds.isNotEmpty) ...[
                  SizedBox(width: 6.w),
                  _TabBadge(
                    count: state.selectedServiceIds.length,
                    colors: colors,
                  ),
                ],
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(tr('claim_coupon.packages')),
                if (state.selectedPackageIds.isNotEmpty) ...[
                  SizedBox(width: 6.w),
                  _TabBadge(
                    count: state.selectedPackageIds.length,
                    colors: colors,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBadge extends StatelessWidget {
  const _TabBadge({required this.count, required this.colors});

  final int count;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: splashOrange,
        borderRadius: BorderRadius.circular(99.r),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ── Step 1: Items content ─────────────────────────────────────────────────────

class _ItemsContent extends StatelessWidget {
  const _ItemsContent({
    required this.tabController,
    required this.state,
    required this.colors,
  });

  final TabController tabController;
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

    return TabBarView(
      controller: tabController,
      children: [
        _ServicesTab(state: state, colors: colors),
        _PackagesTab(state: state, colors: colors),
      ],
    );
  }
}

// ── Services tab ──────────────────────────────────────────────────────────────

class _ServicesTab extends StatelessWidget {
  const _ServicesTab({required this.state, required this.colors});

  final ClaimCouponData state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    if (state.services.isEmpty) {
      return _EmptyTab(colors: colors);
    }
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
      physics: const BouncingScrollPhysics(),
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
    );
  }
}

// ── Packages tab ──────────────────────────────────────────────────────────────

class _PackagesTab extends StatelessWidget {
  const _PackagesTab({required this.state, required this.colors});

  final ClaimCouponData state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    if (state.packages.isEmpty) {
      return _EmptyTab(colors: colors);
    }
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
      physics: const BouncingScrollPhysics(),
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
    );
  }
}

class _EmptyTab extends StatelessWidget {
  const _EmptyTab({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
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
}

// ── Step 2: Schedule content ──────────────────────────────────────────────────

class _ScheduleContent extends StatelessWidget {
  const _ScheduleContent({required this.state, required this.colors});

  final ClaimCouponData state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _DateScroller(state: state, colors: colors)),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 8.h),
          sliver: SliverToBoxAdapter(
            child: Text(
              tr('claim_coupon.choose_time'),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: colors.neutral900,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          sliver: SliverToBoxAdapter(
            child: _SlotsGrid(state: state, colors: colors),
          ),
        ),
        if (state.selectedSlot != null)
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
            sliver: SliverToBoxAdapter(
              child: _SelectedBarberSummary(state: state, colors: colors),
            ),
          ),
        SliverPadding(padding: EdgeInsets.only(bottom: 24.h)),
      ],
    );
  }
}

// ── Date scroller ─────────────────────────────────────────────────────────────

class _DateScroller extends StatelessWidget {
  const _DateScroller({required this.state, required this.colors});

  final ClaimCouponData state;
  final AppColors colors;

  List<DateTime> get _dates {
    final today = DateTime.now();
    return List.generate(14, (i) => today.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    final dates = _dates;
    final selected = state.selectedDate;
    return Container(
      color: colors.neutral50,
      padding: EdgeInsets.fromLTRB(0, 12.h, 0, 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              tr('claim_coupon.choose_date'),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: colors.neutral900,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 72.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: dates.length,
              separatorBuilder: (_, _) => SizedBox(width: 8.w),
              itemBuilder: (context, i) {
                final date = dates[i];
                final isSelected = selected != null &&
                    date.year == selected.year &&
                    date.month == selected.month &&
                    date.day == selected.day;
                return GestureDetector(
                  onTap: () =>
                      context.read<ClaimCouponCubit>().selectDate(date),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 52.w,
                    decoration: BoxDecoration(
                      color: isSelected ? splashOrange : colors.neutral100,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected ? splashOrange : colors.neutral200,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('EEE', context.locale.languageCode).format(date),
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : colors.neutral500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          DateFormat('d', context.locale.languageCode).format(date),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? Colors.white
                                : colors.neutral900,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          DateFormat('MMM', context.locale.languageCode).format(date),
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.8)
                                : colors.neutral400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Slots grid ────────────────────────────────────────────────────────────────

class _SlotsGrid extends StatelessWidget {
  const _SlotsGrid({required this.state, required this.colors});

  final ClaimCouponData state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    if (state.selectedDate == null) {
      return const SizedBox.shrink();
    }
    if (state.isLoadingSlots) {
      return Shimmer.fromColors(
        baseColor: colors.neutral200,
        highlightColor: colors.neutral100,
        child: Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: List.generate(
            8,
            (_) => Container(
              width: 90.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: colors.neutral200,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ),
      );
    }
    if (state.slotsError != null) {
      return Text(
        state.slotsError!,
        style: TextStyle(fontSize: 13.sp, color: colors.neutral500),
      );
    }
    if (state.availableSlots.isEmpty) {
      return Text(
        tr('claim_coupon.no_slots'),
        style: TextStyle(fontSize: 13.sp, color: colors.neutral500),
      );
    }
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: state.availableSlots.map((slot) {
        final isSelected = state.selectedSlot?.startTime == slot.startTime &&
            state.selectedSlot?.endTime == slot.endTime;
        return GestureDetector(
          onTap: () {
            context.read<ClaimCouponCubit>().selectSlot(slot);
            _showBarberSheet(context);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isSelected ? splashOrange : colors.neutral100,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: isSelected ? splashOrange : colors.neutral200,
              ),
            ),
            child: Text(
              _formatTime(slot.startTime),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : colors.neutral700,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatTime(String time) {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } catch (_) {
      return time;
    }
  }

  void _showBarberSheet(BuildContext context) {
    final cubit = context.read<ClaimCouponCubit>();
    final colors = AppColors.of(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _BarberSheet(colors: colors),
      ),
    );
  }
}

// ── Selected barber summary (shown on step 2 after barber chosen) ─────────────

class _SelectedBarberSummary extends StatelessWidget {
  const _SelectedBarberSummary({required this.state, required this.colors});

  final ClaimCouponData state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final barber = state.selectedBarber;
    return GestureDetector(
      onTap: () {
        final cubit = context.read<ClaimCouponCubit>();
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => BlocProvider.value(
            value: cubit,
            child: _BarberSheet(colors: colors),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: colors.neutral100,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: barber != null ? splashOrange : colors.neutral200,
            width: barber != null ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            if (barber != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(18.r),
                child: CachedNetworkImage(
                  imageUrl: barber.avatar,
                  width: 36.r,
                  height: 36.r,
                  fit: BoxFit.cover,
                  placeholder: (_, _) =>
                      Container(width: 36.r, height: 36.r, color: colors.neutral200),
                  errorWidget: (_, _, _) => Container(
                    width: 36.r,
                    height: 36.r,
                    color: colors.neutral200,
                    alignment: Alignment.center,
                    child: Icon(Icons.person_outline_rounded,
                        size: 18.r, color: colors.neutral400),
                  ),
                ),
              )
            else
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: colors.neutral200,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person_outline_rounded,
                    size: 18.r, color: colors.neutral400),
              ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr('claim_coupon.choose_barber'),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: colors.neutral500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    barber?.name ?? tr('claim_coupon.tap_to_choose'),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: barber != null
                          ? colors.neutral900
                          : colors.neutral400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 20.r, color: colors.neutral400),
          ],
        ),
      ),
    );
  }
}

// ── Barber bottom sheet ───────────────────────────────────────────────────────

class _BarberSheet extends StatelessWidget {
  const _BarberSheet({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClaimCouponCubit, ClaimCouponState>(
      builder: (context, state) {
        if (state is! ClaimCouponData) return const SizedBox.shrink();
        return Container(
          decoration: BoxDecoration(
            color: colors.neutral50,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12.h),
              Container(
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colors.neutral300,
                  borderRadius: BorderRadius.circular(99.r),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Text(
                    tr('claim_coupon.choose_barber'),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.neutral900,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              _BarberSheetBody(state: state, colors: colors),
              SizedBox(
                height: MediaQuery.paddingOf(context).bottom + 20.h,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BarberSheetBody extends StatelessWidget {
  const _BarberSheetBody({required this.state, required this.colors});

  final ClaimCouponData state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingBarbers) {
      return Shimmer.fromColors(
        baseColor: colors.neutral200,
        highlightColor: colors.neutral100,
        child: Column(
          children: List.generate(
            3,
            (_) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Container(
                height: 64.h,
                decoration: BoxDecoration(
                  color: colors.neutral200,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (state.barbersError != null) {
      return Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Text(
          state.barbersError!,
          style: TextStyle(fontSize: 13.sp, color: colors.neutral500),
        ),
      );
    }
    if (state.availableBarbers.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Text(
          tr('claim_coupon.no_barbers'),
          style: TextStyle(fontSize: 13.sp, color: colors.neutral500),
        ),
      );
    }
    return Column(
      children: state.availableBarbers.map((barber) {
        final isSelected = state.selectedBarber?.id == barber.id;
        return GestureDetector(
          onTap: () {
            context.read<ClaimCouponCubit>().selectBarber(barber);
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _BarberCard(
              barber: barber,
              isSelected: isSelected,
              colors: colors,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _BarberCard extends StatelessWidget {
  const _BarberCard({
    required this.barber,
    required this.isSelected,
    required this.colors,
  });

  final StaffMember barber;
  final bool isSelected;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected ? splashOrange : colors.neutral200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22.r),
            child: CachedNetworkImage(
              imageUrl: barber.avatar,
              width: 44.r,
              height: 44.r,
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(
                width: 44.r,
                height: 44.r,
                color: colors.neutral200,
              ),
              errorWidget: (_, _, _) => Container(
                width: 44.r,
                height: 44.r,
                color: colors.neutral200,
                alignment: Alignment.center,
                child: Icon(
                  Icons.person_outline_rounded,
                  color: colors.neutral400,
                  size: 22.r,
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
                  barber.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.neutral900,
                  ),
                ),
                if (barber.specialization.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    barber.specialization,
                    style: TextStyle(fontSize: 11.sp, color: colors.neutral500),
                  ),
                ],
              ],
            ),
          ),
          if (isSelected)
            Container(
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                color: splashOrange,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_rounded, size: 13.r, color: Colors.white),
            ),
        ],
      ),
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
    final String label;
    final bool enabled;
    final VoidCallback onTap;

    if (state.step == 1) {
      label = state.canProceed
          ? tr('claim_coupon.next_with_count',
              namedArgs: {'count': '$_totalSelected'})
          : tr('claim_coupon.next');
      enabled = state.canProceed;
      onTap = () {
        if (!state.canProceed) return;
        context.read<ClaimCouponCubit>().goToStep(2);
      };
    } else {
      label = tr('claim_coupon.book');
      enabled = state.canProceedToPayment && !state.isSubmitting;
      onTap = () {
        if (state.isSubmitting) return;
        context.read<ClaimCouponCubit>().confirmBooking();
      };
    }

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
      decoration: BoxDecoration(
        color: colors.neutral50,
        border: Border(top: BorderSide(color: colors.neutral200)),
      ),
      child: AppGradientButton(
        label: label,
        enabled: enabled,
        onTap: onTap,
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
