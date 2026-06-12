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
import 'package:ronaq_barber/features/explore/presentation/components/map_preview_card.dart';
import 'package:ronaq_barber/features/explore/presentation/components/salon_map_view.dart';
import 'package:ronaq_barber/features/explore/presentation/cubit/explore_cubit.dart';
import 'package:ronaq_barber/features/explore/presentation/cubit/explore_state.dart';

class ExploreMapScreen extends StatefulWidget {
  const ExploreMapScreen({super.key});

  @override
  State<ExploreMapScreen> createState() => _ExploreMapScreenState();
}

class _ExploreMapScreenState extends State<ExploreMapScreen> {
  final _sheetController = DraggableScrollableController();
  ScrollController? _sheetScrollController;

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  void _onPinTapped(ExploreLoaded state, int salonId) {
    context.read<ExploreCubit>().highlightSalon(salonId);
    final idx = state.salons.indexWhere((s) => s.id == salonId);
    if (idx == -1) return;

    _sheetController.animateTo(
      0.45,
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

    return Scaffold(
      body: BlocBuilder<ExploreCubit, ExploreState>(
        builder: (context, state) {
          return Stack(
            children: [
              Positioned.fill(
                child: state is ExploreLoaded
                    ? SalonMapView(
                        salons: state.salons,
                        highlightedSalonId: state.highlightedSalonId,
                        onPinTapped: (id) => _onPinTapped(state, id),
                        initialZoom: kExploreMapCamera.zoom,
                      )
                    : Container(color: colors.neutral200),
              ),
              _BackButton(colors: colors),
              DraggableScrollableSheet(
                controller: _sheetController,
                initialChildSize: 0.4,
                minChildSize: 0.12,
                maxChildSize: 0.92,
                snap: true,
                snapSizes: const [0.12, 0.4, 0.92],
                builder: (context, scrollController) {
                  _sheetScrollController = scrollController;
                  return Container(
                    decoration: BoxDecoration(
                      color: colors.neutral50,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.10),
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        SliverToBoxAdapter(child: _SheetHeader(state: state)),
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
                              16.h + MediaQuery.paddingOf(context).bottom,
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
                                    context.read<ExploreCubit>().highlightSalon(
                                      salon.id,
                                    );
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
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      top: MediaQuery.paddingOf(context).top + 8.h,
      start: 16.w,
      child: Material(
        color: colors.neutral50,
        shape: const CircleBorder(),
        elevation: 4,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => context.pop(),
          child: Padding(
            padding: EdgeInsets.all(10.r),
            child: Icon(
              Icons.arrow_back_rounded,
              size: 22.r,
              color: colors.neutral900,
            ),
          ),
        ),
      ),
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
