import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:zain/core/router/app_routes.dart';
import 'package:zain/core/widgets/app_gradient_button.dart';
import 'package:zain/features/book_appointment/domain/entities/staff_member.dart';
import '../cubit/booking_schedule_cubit.dart';
import '../cubit/booking_schedule_state.dart';

class BookingScheduleView extends StatelessWidget {
  const BookingScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocConsumer<BookingScheduleCubit, BookingScheduleState>(
      listenWhen: (prev, curr) {
        if (prev is BookingScheduleForm && curr is BookingScheduleForm) {
          return curr.apiError != null && curr.apiError != prev.apiError;
        }
        return curr is BookingScheduleSuccess;
      },
      listener: (context, state) {
        if (state is BookingScheduleSuccess) {
          context.pushReplacement(
            AppRoutes.checkout,
            extra: state.appointment,
          );
        }
        if (state is BookingScheduleForm && state.apiError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.apiError!)),
          );
        }
      },
      buildWhen: (prev, curr) => curr is BookingScheduleForm,
      builder: (context, state) {
        if (state is! BookingScheduleForm) return const SizedBox.shrink();
        return _ScheduleScaffold(state: state, colors: colors);
      },
    );
  }
}

// ── Scaffold ──────────────────────────────────────────────────────────────────

class _ScheduleScaffold extends StatelessWidget {
  const _ScheduleScaffold({required this.state, required this.colors});

  final BookingScheduleForm state;
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
            Expanded(child: _Content(state: state, colors: colors)),
          ],
        ),
      ),
      bottomNavigationBar: _BottomBar(state: state, colors: colors),
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({required this.state, required this.colors});

  final BookingScheduleForm state;
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
                  tr('claim_coupon.schedule_title'),
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

// ── Content ───────────────────────────────────────────────────────────────────

class _Content extends StatelessWidget {
  const _Content({required this.state, required this.colors});

  final BookingScheduleForm state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: _DateScroller(state: state, colors: colors),
        ),
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

  final BookingScheduleForm state;
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
                      context.read<BookingScheduleCubit>().selectDate(date),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 52.w,
                    decoration: BoxDecoration(
                      color: isSelected ? splashOrange : colors.neutral100,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color:
                            isSelected ? splashOrange : colors.neutral200,
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

  final BookingScheduleForm state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
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
        final isSelected =
            state.selectedSlot?.startTime == slot.startTime &&
                state.selectedSlot?.endTime == slot.endTime;
        return GestureDetector(
          onTap: () {
            context.read<BookingScheduleCubit>().selectSlot(slot);
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
    final cubit = context.read<BookingScheduleCubit>();
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

// ── Selected barber summary ───────────────────────────────────────────────────

class _SelectedBarberSummary extends StatelessWidget {
  const _SelectedBarberSummary({required this.state, required this.colors});

  final BookingScheduleForm state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final barber = state.selectedBarber;
    return GestureDetector(
      onTap: () {
        final cubit = context.read<BookingScheduleCubit>();
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
                  placeholder: (_, _) => Container(
                      width: 36.r, height: 36.r, color: colors.neutral200),
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

// ── Barber sheet ──────────────────────────────────────────────────────────────

class _BarberSheet extends StatelessWidget {
  const _BarberSheet({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingScheduleCubit, BookingScheduleState>(
      builder: (context, state) {
        if (state is! BookingScheduleForm) return const SizedBox.shrink();
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
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  tr('claim_coupon.choose_barber'),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.neutral900,
                  ),
                ),
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

  final BookingScheduleForm state;
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
            context.read<BookingScheduleCubit>().selectBarber(barber);
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
                  width: 44.r, height: 44.r, color: colors.neutral200),
              errorWidget: (_, _, _) => Container(
                width: 44.r,
                height: 44.r,
                color: colors.neutral200,
                alignment: Alignment.center,
                child: Icon(Icons.person_outline_rounded,
                    color: colors.neutral400, size: 22.r),
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
                    style: TextStyle(
                        fontSize: 11.sp, color: colors.neutral500),
                  ),
                ],
              ],
            ),
          ),
          if (isSelected)
            Container(
              width: 22.r,
              height: 22.r,
              decoration: const BoxDecoration(
                color: splashOrange,
                shape: BoxShape.circle,
              ),
              child:
                  Icon(Icons.check_rounded, size: 13.r, color: Colors.white),
            ),
        ],
      ),
    );
  }
}

// ── Bottom bar ────────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.state, required this.colors});

  final BookingScheduleForm state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16.w, 12.h, 16.w, MediaQuery.paddingOf(context).bottom + 12.h,
      ),
      decoration: BoxDecoration(
        color: colors.neutral50,
        border: Border(top: BorderSide(color: colors.neutral200)),
      ),
      child: AppGradientButton(
        label: tr('claim_coupon.book'),
        enabled: state.canConfirm && !state.isSubmitting,
        isLoading: state.isSubmitting,
        onTap: () => context.read<BookingScheduleCubit>().confirmBooking(),
      ),
    );
  }
}
