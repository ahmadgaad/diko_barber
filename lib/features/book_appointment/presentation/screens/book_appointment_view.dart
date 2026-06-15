import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zain/core/router/app_routes.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/core/widgets/app_gradient_button.dart';
import 'package:zain/features/book_appointment/domain/entities/appointment_service.dart';
import 'package:zain/features/book_appointment/domain/entities/staff_member.dart';
import 'package:zain/features/book_appointment/presentation/cubit/book_appointment_cubit.dart';
import 'package:zain/features/book_appointment/presentation/cubit/book_appointment_state.dart';
import 'package:shimmer/shimmer.dart';

class BookAppointmentView extends StatelessWidget {
  const BookAppointmentView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
      builder: (context, state) => switch (state) {
        BookAppointmentLoading() => _LoadingScaffold(colors: colors),
        BookAppointmentError(:final message) =>
          _ErrorScaffold(message: message, colors: colors),
        BookAppointmentSuccess(:final bookingId) =>
          _SuccessScaffold(bookingId: bookingId, colors: colors),
        BookAppointmentData() =>
          _DataScaffold(state: state, colors: colors),
      },
    );
  }
}

// ── Data scaffold ─────────────────────────────────────────────────────────────

class _DataScaffold extends StatelessWidget {
  const _DataScaffold({required this.state, required this.colors});

  final BookAppointmentData state;
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
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _stepContent(context, state, colors),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomActionBar(state: state, colors: colors),
    );
  }

  Widget _stepContent(
    BuildContext context,
    BookAppointmentData state,
    AppColors colors,
  ) {
    return switch (state.step) {
      1 => _Step1Services(
          key: const ValueKey(1),
          state: state,
          colors: colors,
        ),
      2 => _Step2Staff(
          key: const ValueKey(2),
          state: state,
          colors: colors,
        ),
      3 => _Step3DateTime(
          key: const ValueKey(3),
          state: state,
          colors: colors,
        ),
      4 => _Step4Review(
          key: const ValueKey(4),
          state: state,
          colors: colors,
        ),
      _ => const SizedBox.shrink(),
    };
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({required this.state, required this.colors});

  final BookAppointmentData state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.neutral50,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        children: [
          Row(
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
                      tr('book_appointment.title'),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.neutral900,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      state.salonName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: colors.neutral500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 38.r),
            ],
          ),
          SizedBox(height: 14.h),
          _StepProgressBar(currentStep: state.step, colors: colors),
        ],
      ),
    );
  }
}

// ── Step progress ─────────────────────────────────────────────────────────────

class _StepProgressBar extends StatelessWidget {
  const _StepProgressBar({required this.currentStep, required this.colors});

  final int currentStep;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (i) {
        final isActive = i < currentStep;
        return Expanded(
          child: Container(
            height: 4.h,
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            decoration: BoxDecoration(
              color: isActive ? splashOrange : colors.neutral200,
              borderRadius: BorderRadius.circular(999.r),
            ),
          ),
        );
      }),
    );
  }
}

// ── Bottom action bar ─────────────────────────────────────────────────────────

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({required this.state, required this.colors});

  final BookAppointmentData state;
  final AppColors colors;

  bool get _canProceed {
    return switch (state.step) {
      1 => state.canProceedStep1,
      2 => state.canProceedStep2,
      3 => state.canProceedStep3,
      _ => true,
    };
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BookAppointmentCubit>();
    final isLastStep = state.step == 4;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
      decoration: BoxDecoration(
        color: colors.neutral50,
        border: Border(top: BorderSide(color: colors.neutral200)),
      ),
      child: Row(
        children: [
          if (state.step > 1) ...[
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => cubit.goToStep(state.step - 1),
                child: Container(
                  height: 52.h,
                  decoration: BoxDecoration(
                    color: colors.neutral100,
                    borderRadius: BorderRadius.circular(999.r),
                    border: Border.all(color: colors.neutral200),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    tr('book_appointment.back'),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.neutral700,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
          ],
          Expanded(
            flex: 3,
            child: AppGradientButton(
              label: isLastStep
                  ? tr('book_appointment.confirm')
                  : tr('book_appointment.next'),
              isLoading: state.isSubmitting,
              enabled: _canProceed,
              onTap: () {
                if (!_canProceed) return;
                if (isLastStep) {
                  cubit.confirmBooking();
                } else {
                  cubit.goToStep(state.step + 1);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step 1 — Select Service ───────────────────────────────────────────────────

class _Step1Services extends StatelessWidget {
  const _Step1Services({
    super.key,
    required this.state,
    required this.colors,
  });

  final BookAppointmentData state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
          child: Text(
            tr('book_appointment.select_service'),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: colors.neutral900,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            physics: const BouncingScrollPhysics(),
            itemCount: state.services.length,
            separatorBuilder: (_, _) => SizedBox(height: 10.h),
            itemBuilder: (context, i) => _ServiceCard(
              service: state.services[i],
              isSelected: state.selectedService?.id == state.services[i].id,
              colors: colors,
            ),
          ),
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.service,
    required this.isSelected,
    required this.colors,
  });

  final AppointmentService service;
  final bool isSelected;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.read<BookAppointmentCubit>().selectService(service),
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
                  SizedBox(height: 4.h),
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
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.star_rounded,
                        size: 13.r,
                        color: const Color(0xFFFFC107),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        service.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: colors.neutral700,
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
                  '${service.price.toInt()} ${tr('home.currency')}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: splashOrange,
                  ),
                ),
                SizedBox(height: 6.h),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22.r,
                  height: 22.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? splashOrange : Colors.transparent,
                    border: Border.all(
                      color:
                          isSelected ? splashOrange : colors.neutral300,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Icon(Icons.check_rounded,
                          size: 13.r, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step 2 — Select Staff ─────────────────────────────────────────────────────

class _Step2Staff extends StatelessWidget {
  const _Step2Staff({
    super.key,
    required this.state,
    required this.colors,
  });

  final BookAppointmentData state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
          child: Text(
            tr('book_appointment.select_staff'),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: colors.neutral900,
            ),
          ),
        ),
        Expanded(
          child: state.isLoadingStaff
              ? _StaffShimmer(colors: colors)
              : ListView.separated(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.staff.length + 1,
                  separatorBuilder: (_, _) => SizedBox(height: 10.h),
                  itemBuilder: (context, i) {
                    if (i == 0) {
                      return _AnyStaffCard(
                        isSelected:
                            state.staffSelected && state.selectedStaff == null,
                        colors: colors,
                      );
                    }
                    final member = state.staff[i - 1];
                    return _StaffCard(
                      member: member,
                      isSelected: state.selectedStaff?.id == member.id,
                      colors: colors,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _AnyStaffCard extends StatelessWidget {
  const _AnyStaffCard({required this.isSelected, required this.colors});

  final bool isSelected;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<BookAppointmentCubit>().selectStaff(null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(14.w),
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
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                color: splashOrange.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.groups_2_rounded,
                size: 24.r,
                color: splashOrange,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr('book_appointment.any_staff'),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.neutral900,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    tr('book_appointment.any_staff_label'),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: colors.neutral500,
                    ),
                  ),
                ],
              ),
            ),
            _SelectionCircle(isSelected: isSelected, colors: colors),
          ],
        ),
      ),
    );
  }
}

class _StaffCard extends StatelessWidget {
  const _StaffCard({
    required this.member,
    required this.isSelected,
    required this.colors,
  });

  final StaffMember member;
  final bool isSelected;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<BookAppointmentCubit>().selectStaff(member),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(14.w),
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
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: member.avatar,
                width: 48.r,
                height: 48.r,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                  width: 48.r,
                  height: 48.r,
                  color: colors.neutral200,
                ),
                errorWidget: (_, _, _) => Container(
                  width: 48.r,
                  height: 48.r,
                  color: colors.neutral200,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 24.r,
                    color: colors.neutral400,
                  ),
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.neutral900,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    member.specialization,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: colors.neutral500,
                    ),
                  ),
                ],
              ),
            ),
            _SelectionCircle(isSelected: isSelected, colors: colors),
          ],
        ),
      ),
    );
  }
}

class _SelectionCircle extends StatelessWidget {
  const _SelectionCircle({required this.isSelected, required this.colors});

  final bool isSelected;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 22.r,
      height: 22.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
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

class _StaffShimmer extends StatelessWidget {
  const _StaffShimmer({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: colors.neutral200,
      highlightColor: colors.neutral100,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        separatorBuilder: (_, _) => SizedBox(height: 10.h),
        itemBuilder: (_, _) => Container(
          height: 76.h,
          decoration: BoxDecoration(
            color: colors.neutral200,
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
      ),
    );
  }
}

// ── Step 3 — Date & Time ──────────────────────────────────────────────────────

class _Step3DateTime extends StatelessWidget {
  const _Step3DateTime({
    super.key,
    required this.state,
    required this.colors,
  });

  final BookAppointmentData state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
          child: Text(
            tr('book_appointment.select_datetime'),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: colors.neutral900,
            ),
          ),
        ),
        _DateScroller(state: state, colors: colors),
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            tr('book_appointment.available_times'),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: colors.neutral700,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Expanded(
          child: state.isLoadingSlots
              ? _SlotsShimmer(colors: colors)
              : _SlotGrid(state: state, colors: colors),
        ),
      ],
    );
  }
}

class _DateScroller extends StatelessWidget {
  const _DateScroller({required this.state, required this.colors});

  final BookAppointmentData state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dates = List.generate(14, (i) => today.add(Duration(days: i)));
    final dayAbbrevs = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return SizedBox(
      height: 72.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        physics: const BouncingScrollPhysics(),
        itemCount: dates.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, i) {
          final date = dates[i];
          final isSelected =
              state.selectedDate.day == date.day &&
              state.selectedDate.month == date.month &&
              state.selectedDate.year == date.year;
          return GestureDetector(
            onTap: () =>
                context.read<BookAppointmentCubit>().selectDate(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 50.w,
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
                    dayAbbrevs[date.weekday % 7],
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.85)
                          : colors.neutral500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : colors.neutral900,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SlotGrid extends StatelessWidget {
  const _SlotGrid({required this.state, required this.colors});

  final BookAppointmentData state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    if (state.slots.isEmpty) {
      return Center(
        child: Text(
          tr('book_appointment.no_slots'),
          style: TextStyle(fontSize: 14.sp, color: colors.neutral500),
        ),
      );
    }
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      physics: const BouncingScrollPhysics(),
      child: Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        children: state.slots.map((slot) {
          final isSelected = state.selectedSlot?.id == slot.id;
          return GestureDetector(
            onTap: slot.isAvailable
                ? () =>
                    context.read<BookAppointmentCubit>().selectSlot(slot)
                : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? splashOrange
                    : slot.isAvailable
                        ? colors.neutral100
                        : colors.neutral200,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: isSelected
                      ? splashOrange
                      : slot.isAvailable
                          ? colors.neutral200
                          : colors.neutral200,
                ),
              ),
              child: Text(
                slot.time,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : slot.isAvailable
                          ? colors.neutral800
                          : colors.neutral400,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SlotsShimmer extends StatelessWidget {
  const _SlotsShimmer({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: colors.neutral200,
      highlightColor: colors.neutral100,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: List.generate(
            8,
            (_) => Container(
              width: 80.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: colors.neutral200,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Step 4 — Review ───────────────────────────────────────────────────────────

class _Step4Review extends StatelessWidget {
  const _Step4Review({
    super.key,
    required this.state,
    required this.colors,
  });

  final BookAppointmentData state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr('book_appointment.review'),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: colors.neutral900,
            ),
          ),
          SizedBox(height: 16.h),
          _SummaryCard(state: state, colors: colors),
          SizedBox(height: 16.h),
          _PriceCard(state: state, colors: colors),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.state, required this.colors});

  final BookAppointmentData state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final service = state.selectedService!;
    final slot = state.selectedSlot!;
    final date = DateFormat(
      'dd MMM yyyy',
      context.locale.languageCode,
    ).format(state.selectedDate);

    return Container(
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: Column(
        children: [
          _ReviewRow(
            icon: Icons.store_outlined,
            label: tr('home.salon'),
            value: state.salonName,
            colors: colors,
            isFirst: true,
          ),
          _ReviewRow(
            icon: Icons.content_cut_rounded,
            label: tr('book_appointment.select_service'),
            value: service.name,
            colors: colors,
          ),
          _ReviewRow(
            icon: Icons.person_outline_rounded,
            label: tr('book_appointment.select_staff'),
            value: state.selectedStaff?.name ?? tr('book_appointment.any_staff_label'),
            colors: colors,
          ),
          _ReviewRow(
            icon: Icons.calendar_today_outlined,
            label: tr('home.valid_from'),
            value: date,
            colors: colors,
          ),
          _ReviewRow(
            icon: Icons.access_time_rounded,
            label: tr('book_appointment.available_times'),
            value: slot.time,
            colors: colors,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.colors,
    this.isFirst = false,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final AppColors colors;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!isFirst) Divider(height: 1, thickness: 1, color: colors.neutral200),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              Icon(icon, size: 15.r, color: colors.neutral400),
              SizedBox(width: 10.w),
              Text(
                label,
                style: TextStyle(fontSize: 12.sp, color: colors.neutral500),
              ),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.neutral900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PriceCard extends StatelessWidget {
  const _PriceCard({required this.state, required this.colors});

  final BookAppointmentData state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final hasCoupon = state.couponCode != null;
    final isValidating = state.isValidatingCoupon;
    final validation = state.couponValidation;

    return Container(
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              children: [
                Text(
                  tr('book_appointment.price_breakdown'),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.neutral900,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: colors.neutral200),
          _PriceRow(
            label: tr('book_appointment.original_price'),
            value:
                '${state.originalPrice.toInt()} ${tr('home.currency')}',
            colors: colors,
          ),
          if (hasCoupon) ...[
            Divider(height: 1, thickness: 1, color: colors.neutral200),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: Row(
                children: [
                  Icon(
                    Icons.local_offer_outlined,
                    size: 14.r,
                    color: splashOrange,
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      tr(
                        'book_appointment.discount',
                        namedArgs: {'code': state.couponCode!},
                      ),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: colors.neutral500,
                      ),
                    ),
                  ),
                  if (isValidating) ...[
                    SizedBox(
                      width: 14.r,
                      height: 14.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: splashOrange,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      tr('book_appointment.coupon_validating'),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: colors.neutral400,
                      ),
                    ),
                  ] else if (validation != null && validation.isValid) ...[
                    Text(
                      '- ${state.discountAmount.toInt()} ${tr('home.currency')}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.success600,
                      ),
                    ),
                  ] else ...[
                    Text(
                      tr('book_appointment.coupon_invalid'),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: colors.error600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
          Divider(height: 1, thickness: 1, color: colors.neutral200),
          _PriceRow(
            label: tr('book_appointment.total'),
            value: '${state.finalPrice.toInt()} ${tr('home.currency')}',
            colors: colors,
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    required this.colors,
    this.isTotal = false,
  });

  final String label;
  final String value;
  final AppColors colors;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
              color: isTotal ? colors.neutral900 : colors.neutral500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 15.sp : 13.sp,
              fontWeight: FontWeight.w700,
              color: isTotal ? splashOrange : colors.neutral800,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Success scaffold ──────────────────────────────────────────────────────────

class _SuccessScaffold extends StatelessWidget {
  const _SuccessScaffold({required this.bookingId, required this.colors});

  final int bookingId;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.neutral50,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80.r,
                  height: 80.r,
                  decoration: BoxDecoration(
                    color: splashOrange.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline_rounded,
                    size: 44.r,
                    color: splashOrange,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  tr('book_appointment.booking_confirmed'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: colors.neutral900,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: splashOrange.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(999.r),
                    border: Border.all(
                      color: splashOrange.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    tr(
                      'book_appointment.booking_id',
                      namedArgs: {'id': '$bookingId'},
                    ),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: splashOrange,
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                AppGradientButton(
                  label: tr('book_appointment.view_bookings'),
                  onTap: () => context.go(AppRoutes.home),
                ),
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    height: 52.h,
                    decoration: BoxDecoration(
                      color: colors.neutral100,
                      borderRadius: BorderRadius.circular(999.r),
                      border: Border.all(color: colors.neutral200),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      tr('book_appointment.done'),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.neutral700,
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
                      height: 80.h,
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
              style: TextStyle(
                fontSize: 14.sp,
                color: colors.neutral600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
