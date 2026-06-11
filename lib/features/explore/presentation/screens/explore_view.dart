import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/features/explore/presentation/components/category_filter_chips.dart';
import 'package:ronaq_barber/features/explore/presentation/components/explore_empty_state.dart';
import 'package:ronaq_barber/features/explore/presentation/components/explore_shimmer.dart';
import 'package:ronaq_barber/features/explore/presentation/components/salon_grid_card.dart';
import 'package:ronaq_barber/features/explore/presentation/components/salon_map_view.dart';
import 'package:ronaq_barber/features/explore/presentation/cubit/explore_cubit.dart';
import 'package:ronaq_barber/features/explore/presentation/cubit/explore_state.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key, this.onSheetSizeChanged});

  final void Function(double size, double maxSize)? onSheetSizeChanged;

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final _sheetController = DraggableScrollableController();
  ScrollController? _sheetScrollController;

  static const _maxSize = 0.92;
  static const _midSize = 0.4;

  // Cached once so snap points stay identical across rebuilds.
  static const _snapSizes = [_midSize, _maxSize];

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(_onSheetScroll);
  }

  void _onSheetScroll() {
    if (!_sheetController.isAttached) return;
    widget.onSheetSizeChanged?.call(_sheetController.size, _maxSize);
  }

  @override
  void dispose() {
    _sheetController.removeListener(_onSheetScroll);
    _sheetController.dispose();
    super.dispose();
  }

  void _onPinTapped(ExploreLoaded state, int salonId) {
    context.read<ExploreCubit>().highlightSalon(salonId);
    final idx = state.salons.indexWhere((s) => s.id == salonId);
    if (idx == -1) return;

    _sheetController.animateTo(
      _midSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final scroll = _sheetScrollController;
      if (scroll == null || !scroll.hasClients) return;
      final rowIndex = idx ~/ 2;
      scroll.animateTo(
        rowIndex * 220.h,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final navBarHeight = 88.h + MediaQuery.paddingOf(context).bottom;

    return Stack(
      children: [
        // Map layer — only rebuilds on relevant state changes.
        Positioned.fill(
          child: BlocBuilder<ExploreCubit, ExploreState>(
            buildWhen: (p, c) =>
                p.runtimeType != c.runtimeType ||
                (p is ExploreLoaded &&
                    c is ExploreLoaded &&
                    (p.salons != c.salons ||
                        p.highlightedSalonId != c.highlightedSalonId)),
            builder: (context, state) => state is ExploreLoaded
                ? SalonMapView(
                    salons: state.salons,
                    highlightedSalonId: state.highlightedSalonId,
                    onPinTapped: (id) => _onPinTapped(state, id),
                  )
                : Container(color: colors.neutral200),
          ),
        ),

        // Sheet — stable widget tree; BlocBuilder lives only inside the content.
        DraggableScrollableSheet(
          controller: _sheetController,
          initialChildSize: _midSize,
          minChildSize: _midSize,
          maxChildSize: _maxSize,
          snap: true,
          snapSizes: _snapSizes,
          builder: (context, scrollController) {
            _sheetScrollController = scrollController;
            return DecoratedBox(
              decoration: BoxDecoration(
                color: colors.neutral50,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Fixed header — never scrolls; GestureDetector forwards
                  // vertical drags to the sheet controller so the header drag
                  // handle actually moves the sheet.
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onVerticalDragUpdate: (details) {
                      if (!_sheetController.isAttached) return;
                      final screenH = MediaQuery.sizeOf(context).height;
                      _sheetController.jumpTo(
                        (_sheetController.size -
                                details.primaryDelta! / screenH)
                            .clamp(_midSize, _maxSize),
                      );
                    },
                    onVerticalDragEnd: (details) {
                      if (!_sheetController.isAttached) return;
                      final velocity = details.primaryVelocity ?? 0;
                      final current = _sheetController.size;
                      final double target;
                      if (velocity < -500) {
                        target = _maxSize;
                      } else if (velocity > 500) {
                        target = _midSize;
                      } else {
                        target = _snapSizes.reduce(
                          (a, b) =>
                              (a - current).abs() < (b - current).abs() ? a : b,
                        );
                      }
                      _sheetController.animateTo(
                        target,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    },
                    child: BlocBuilder<ExploreCubit, ExploreState>(
                      builder: (context, state) => _SheetHeader(state: state),
                    ),
                  ),
                  // Scrollable content only.
                  Expanded(
                    child: BlocBuilder<ExploreCubit, ExploreState>(
                      builder: (context, state) => CustomScrollView(
                        controller: scrollController,
                        physics: const ClampingScrollPhysics(),
                        slivers: [
                          switch (state) {
                            ExploreLoading() => SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: const ExploreShimmer(),
                              ),
                            ),
                            ExploreLoaded() when state.salons.isEmpty =>
                              const SliverFillRemaining(
                                hasScrollBody: false,
                                child: ExploreEmptyState(
                                  icon: Icons.search_off_rounded,
                                  titleKey: 'explore.no_results_title',
                                  bodyKey: 'explore.no_results_body',
                                ),
                              ),
                            ExploreLoaded() => SliverPadding(
                              padding: EdgeInsets.fromLTRB(
                                16.w,
                                0,
                                16.w,
                                navBarHeight,
                              ),
                              sliver: SliverGrid.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12.w,
                                      mainAxisSpacing: 12.h,
                                      childAspectRatio: 0.78,
                                    ),
                                itemCount: state.salons.length,
                                itemBuilder: (context, index) {
                                  final salon = state.salons[index];
                                  return SalonGridCard(
                                    salon: salon,
                                    isHighlighted:
                                        salon.id == state.highlightedSalonId,
                                    onTap: () {
                                      context
                                          .read<ExploreCubit>()
                                          .highlightSalon(salon.id);
                                      context.push('/salon/${salon.id}');
                                    },
                                  );
                                },
                              ),
                            ),
                            ExploreError() => const SliverFillRemaining(
                              hasScrollBody: false,
                              child: ExploreEmptyState(
                                icon: Icons.error_outline_rounded,
                                titleKey: 'explore.error_title',
                                bodyKey: 'explore.error_body',
                              ),
                            ),
                          },
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.state});
  final ExploreState state;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: colors.neutral300,
              borderRadius: BorderRadius.circular(999.r),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
          child: Row(
            children: [
              Text(
                tr('nav.explore'),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.neutral900,
                ),
              ),
              if (state case ExploreLoaded(:final salons)) ...[
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: splashOrange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    '${salons.length}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: splashOrange,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (state case ExploreLoaded(
          :final categories,
          :final selectedCategory,
        ))
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 12.h),
            child: CategoryFilterChips(
              categories: categories,
              selectedCategory: selectedCategory,
            ),
          ),
      ],
    );
  }
}
