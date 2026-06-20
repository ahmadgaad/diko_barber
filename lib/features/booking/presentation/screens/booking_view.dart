import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/features/booking/presentation/components/booking_card.dart';
import 'package:zain/features/booking/presentation/components/booking_shimmer_card.dart';
import 'package:zain/features/booking/presentation/components/bookings_empty_state.dart';
import 'package:zain/features/booking/presentation/components/bookings_error_state.dart';
import 'package:zain/features/booking/presentation/components/status_filter_chips.dart';
import 'package:zain/features/booking/presentation/cubit/bookings_cubit.dart';
import 'package:zain/features/booking/presentation/cubit/bookings_state.dart';

class BookingView extends StatelessWidget {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 12.h, 16.w, 0),
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
                BookingsError() => BookingsErrorState(colors: colors),
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

class _LoadedContent extends StatelessWidget {
  const _LoadedContent({required this.state, required this.colors});

  final BookingsLoaded state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatusFilterChips(
          filters: state.filters,
          selectedIndex: state.selectedFilterIndex,
          colors: colors,
        ),
        SizedBox(height: 12.h),
        Expanded(
          child: state.isLoadingBookings
              ? _BookingsListShimmer(colors: colors)
              : RefreshIndicator.adaptive(
                  color: splashOrange,
                  onRefresh: () => context.read<BookingsCubit>().refresh(),
                  child: state.bookings.isEmpty
                      ? LayoutBuilder(
                          builder: (context, constraints) => ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight,
                                ),
                                child: Center(
                                  child: BookingsEmptyState(colors: colors),
                                ),
                              ),
                            ],
                          ),
                        )
                      : NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification is ScrollEndNotification &&
                                notification.metrics.pixels >=
                                    notification.metrics.maxScrollExtent - 200) {
                              context.read<BookingsCubit>().loadMore();
                            }
                            return false;
                          },
                          child: ListView.separated(
                            padding: EdgeInsets.only(bottom: 120.h, left: 16.w),
                            physics: const ClampingScrollPhysics(),
                            itemCount: state.bookings.length +
                                (state.isLoadingMore ? 1 : 0),
                            separatorBuilder: (_, _) =>
                                SizedBox(height: 10.h),
                            itemBuilder: (context, i) {
                              if (i == state.bookings.length) {
                                return Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 16.h),
                                  child: Center(
                                    child: SizedBox(
                                      width: 24.r,
                                      height: 24.r,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: splashOrange,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return BookingCard(
                                booking: state.bookings[i],
                                colors: colors,
                              );
                            },
                          ),
                        ),
                ),
        ),
      ],
    );
  }
}

class _BookingsListShimmer extends StatelessWidget {
  const _BookingsListShimmer({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (_, _) => SizedBox(height: 10.h),
        itemBuilder: (_, _) => BookingShimmerCard(colors: colors),
      ),
    );
  }
}

class _BookingsShimmer extends StatelessWidget {
  const _BookingsShimmer({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: colors.neutral200,
          highlightColor: colors.neutral100,
          child: SingleChildScrollView(
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
                      color: colors.neutral300,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Expanded(
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (_, _) => SizedBox(height: 10.h),
            itemBuilder: (_, _) => BookingShimmerCard(colors: colors),
          ),
        ),
      ],
    );
  }
}
