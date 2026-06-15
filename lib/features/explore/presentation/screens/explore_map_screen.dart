import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/features/explore/presentation/components/explore_back_button.dart';
import 'package:zain/features/explore/presentation/components/explore_empty_state.dart';
import 'package:zain/features/explore/presentation/components/explore_map_sheet_header.dart';
import 'package:zain/features/explore/presentation/components/explore_shimmer.dart';
import 'package:zain/features/explore/presentation/components/map_preview_card.dart';
import 'package:zain/features/explore/presentation/components/salon_grid_card.dart';
import 'package:zain/features/explore/presentation/components/salon_map_view.dart';
import 'package:zain/features/explore/presentation/cubit/explore_cubit.dart';
import 'package:zain/features/explore/presentation/cubit/explore_state.dart';

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
              const ExploreBackButton(),
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
                        SliverToBoxAdapter(
                          child: ExploreMapSheetHeader(state: state),
                        ),
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

