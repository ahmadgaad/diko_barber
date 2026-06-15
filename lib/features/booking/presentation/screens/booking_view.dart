import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/shared/domain/entities/booking.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/features/booking/presentation/cubit/bookings_cubit.dart';
import 'package:zain/features/booking/presentation/cubit/bookings_state.dart';
import 'package:shimmer/shimmer.dart';

class BookingView extends StatelessWidget {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr('nav.bookings'),
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: colors.neutral900,
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: BlocBuilder<BookingsCubit, BookingsState>(
              builder: (context, state) => switch (state) {
                BookingsLoading() => _BookingsShimmer(colors: colors),
                BookingsError() => _ErrorState(colors: colors),
                BookingsLoaded() => _LoadedContent(
                  state: state,
                  colors: colors,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Loaded content ────────────────────────────────────────────────────────────

class _LoadedContent extends StatelessWidget {
  const _LoadedContent({required this.state, required this.colors});

  final BookingsLoaded state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StatusFilterChips(
          selectedStatus: state.selectedStatus,
          colors: colors,
        ),
        SizedBox(height: 12.h),
        Expanded(
          child: state.filtered.isEmpty
              ? _EmptyState(colors: colors)
              : ListView.separated(
                  padding: EdgeInsets.only(bottom: 16.h),
                  physics: const ClampingScrollPhysics(),
                  itemCount: state.filtered.length,
                  separatorBuilder: (_, _) => SizedBox(height: 10.h),
                  itemBuilder: (context, i) =>
                      _BookingCard(booking: state.filtered[i], colors: colors),
                ),
        ),
      ],
    );
  }
}

// ── Status filter chips ───────────────────────────────────────────────────────

class _StatusFilterChips extends StatelessWidget {
  const _StatusFilterChips({
    required this.selectedStatus,
    required this.colors,
  });

  final BookingStatus? selectedStatus;
  final AppColors colors;

  static const _filters = <BookingStatus?>[
    null,
    BookingStatus.pending,
    BookingStatus.confirmed,
    BookingStatus.completed,
    BookingStatus.cancelled,
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((status) {
          final isSelected = selectedStatus == status;
          return Padding(
            padding: EdgeInsetsDirectional.only(end: 8.w),
            child: GestureDetector(
              onTap: () => context.read<BookingsCubit>().filterByStatus(status),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? splashOrange : colors.neutral100,
                  borderRadius: BorderRadius.circular(999.r),
                  border: Border.all(
                    color: isSelected ? splashOrange : colors.neutral200,
                  ),
                ),
                child: Text(
                  _statusLabel(status),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? Colors.white : colors.neutral600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _statusLabel(BookingStatus? status) => switch (status) {
    null => tr('bookings.filter_all'),
    BookingStatus.pending => tr('bookings.status_pending'),
    BookingStatus.confirmed => tr('bookings.status_confirmed'),
    BookingStatus.completed => tr('bookings.status_completed'),
    BookingStatus.cancelled => tr('bookings.status_cancelled'),
  };
}

// ── Booking card ──────────────────────────────────────────────────────────────

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking, required this.colors});

  final Booking booking;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: salon logo + name + status badge ──────────────────────
          Row(
            children: [
              _SalonLogo(url: booking.salonLogo, colors: colors),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.salonName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.neutral900,
                      ),
                    ),
                    if (booking.staffName != null) ...[
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 12.r,
                            color: colors.neutral400,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            booking.staffName!,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: colors.neutral500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              _StatusBadge(status: booking.status, colors: colors),
            ],
          ),

          SizedBox(height: 12.h),
          Divider(color: colors.neutral200, height: 1),
          SizedBox(height: 12.h),

          // ── Service name ──────────────────────────────────────────────────
          Row(
            children: [
              Icon(
                Icons.content_cut_rounded,
                size: 15.r,
                color: colors.neutral400,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  booking.serviceName,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.neutral800,
                  ),
                ),
              ),
              Text(
                '${booking.price.toInt()} ${tr('home.currency')}',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: splashOrange,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // ── Date / time / address ─────────────────────────────────────────
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 13.r,
                color: colors.neutral400,
              ),
              SizedBox(width: 6.w),
              Text(
                DateFormat(
                  'EEE, dd MMM yyyy · HH:mm',
                  context.locale.languageCode,
                ).format(booking.dateTime),
                style: TextStyle(fontSize: 12.sp, color: colors.neutral500),
              ),
            ],
          ),

          if (booking.address != null) ...[
            SizedBox(height: 6.h),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 13.r,
                  color: colors.neutral400,
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    booking.address!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.sp, color: colors.neutral500),
                  ),
                ),
              ],
            ),
          ],

          // ── Action buttons ────────────────────────────────────────────────
          if (booking.status == BookingStatus.completed ||
              booking.status == BookingStatus.pending ||
              booking.status == BookingStatus.confirmed) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                if (booking.status == BookingStatus.completed)
                  Expanded(
                    child: _ActionButton(
                      label: tr('bookings.book_again'),
                      isPrimary: true,
                      onTap: () {},
                    ),
                  ),
                if (booking.status == BookingStatus.pending ||
                    booking.status == BookingStatus.confirmed) ...[
                  Expanded(
                    child: _ActionButton(
                      label: tr('bookings.cancel'),
                      isPrimary: false,
                      onTap: () {},
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _ActionButton(
                      label: tr('bookings.view_details'),
                      isPrimary: true,
                      onTap: () {},
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Status badge ──────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status, required this.colors});

  final BookingStatus status;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = switch (status) {
      BookingStatus.pending => (
        colors.warning100,
        colors.warning600,
        tr('bookings.status_pending'),
      ),
      BookingStatus.confirmed => (
        colors.info100,
        colors.info600,
        tr('bookings.status_confirmed'),
      ),
      BookingStatus.completed => (
        colors.success100,
        colors.success600,
        tr('bookings.status_completed'),
      ),
      BookingStatus.cancelled => (
        colors.error100,
        colors.error600,
        tr('bookings.status_cancelled'),
      ),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

// ── Action button ─────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPrimary ? splashOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isPrimary ? splashOrange : colors.neutral300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: isPrimary ? Colors.white : colors.neutral700,
          ),
        ),
      ),
    );
  }
}

// ── Salon logo ────────────────────────────────────────────────────────────────

class _SalonLogo extends StatelessWidget {
  const _SalonLogo({required this.url, required this.colors});

  final String url;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: CachedNetworkImage(
        imageUrl: url,
        width: 44.r,
        height: 44.r,
        fit: BoxFit.cover,
        placeholder: (_, _) =>
            Container(width: 44.r, height: 44.r, color: colors.neutral200),
        errorWidget: (_, _, _) => Container(
          width: 44.r,
          height: 44.r,
          color: colors.neutral200,
          alignment: Alignment.center,
          child: Icon(
            Icons.store_outlined,
            color: colors.neutral400,
            size: 20.r,
          ),
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 64.r,
            color: colors.neutral300,
          ),
          SizedBox(height: 16.h),
          Text(
            tr('bookings.empty_title'),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: colors.neutral700,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            tr('bookings.empty_body'),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.sp, color: colors.neutral500),
          ),
        ],
      ),
    );
  }
}

// ── Error state ───────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Center(
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
            tr('explore.error_title'),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: colors.neutral700,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shimmer ───────────────────────────────────────────────────────────────────

class _BookingsShimmer extends StatelessWidget {
  const _BookingsShimmer({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: colors.neutral200,
      highlightColor: colors.neutral100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter chips placeholder
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              children: List.generate(5, (_) {
                return Padding(
                  padding: EdgeInsetsDirectional.only(end: 8.w),
                  child: Container(
                    width: 70.w,
                    height: 34.h,
                    decoration: BoxDecoration(
                      color: colors.neutral200,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 16.h),
          // Booking card placeholders
          ...List.generate(3, (_) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Container(
                height: 160.h,
                decoration: BoxDecoration(
                  color: colors.neutral200,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
