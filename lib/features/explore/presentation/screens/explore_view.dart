import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/core/widgets/app_snack_bar.dart';
import 'package:zain/core/widgets/auth_gate.dart';
import 'package:zain/features/explore/presentation/components/explore_empty_state.dart';
import 'package:zain/features/explore/presentation/components/explore_sheet_header.dart';
import 'package:zain/features/explore/presentation/components/explore_shimmer.dart';
import 'package:zain/features/explore/presentation/components/salon_grid_card.dart';
import 'package:zain/features/explore/presentation/components/salon_map_view.dart';
import 'package:zain/features/explore/presentation/cubit/explore_cubit.dart';
import 'package:zain/features/explore/presentation/cubit/explore_state.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key, this.onSheetSizeChanged});

  final void Function(double size, double maxSize)? onSheetSizeChanged;

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final _sheetController = DraggableScrollableController();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  ScrollController? _sheetScrollController;

  static const _maxSize = 0.92;
  static const _midSize = 0.4;

  // Cached once so snap points stay identical across rebuilds.
  static const _snapSizes = [_midSize, _maxSize];

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(_onSheetScroll);
    _searchFocusNode.addListener(_onSearchFocusChanged);
  }

  void _onSearchFocusChanged() {
    if (_searchFocusNode.hasFocus && _sheetController.isAttached) {
      _sheetController.animateTo(
        _maxSize,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _onSheetScroll() {
    if (!_sheetController.isAttached) return;
    widget.onSheetSizeChanged?.call(_sheetController.size, _maxSize);
  }

  @override
  void dispose() {
    _sheetController.removeListener(_onSheetScroll);
    _sheetController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<Widget> _buildSlivers(
    BuildContext context,
    ExploreState state,
    double navBarHeight,
  ) {
    return switch (state) {
      ExploreLoading() => [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const ExploreShimmer(),
          ),
        ),
      ],
      ExploreLoaded() when state.isLoadingSalons => [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const ExploreShimmer(showCategoryChips: false),
          ),
        ),
      ],
      ExploreLoaded() when state.salons.isEmpty => [
        const SliverFillRemaining(
          hasScrollBody: false,
          child: ExploreEmptyState(
            icon: Icons.search_off_rounded,
            titleKey: 'explore.no_results_title',
            bodyKey: 'explore.no_results_body',
          ),
        ),
      ],
      ExploreLoaded() => [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
          sliver: SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.85,
            ),
            itemCount: state.salons.length,
            itemBuilder: (context, index) {
              final salon = state.salons[index];
              return SalonGridCard(
                salon: salon,
                isHighlighted: salon.id == state.highlightedSalonId,
                onTap: () => AuthGate.guard(context, () {
                  context.read<ExploreCubit>().highlightSalon(salon.id);
                  context.push('/salon/${salon.id}');
                }),
                onFavoriteTap: () => AuthGate.guard(
                  context,
                  () => context.read<ExploreCubit>().toggleFavorite(salon.id),
                ),
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: state.isLoadingMore
              ? Padding(
                  padding: EdgeInsets.fromLTRB(0, 16.h, 0, navBarHeight),
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : SizedBox(height: navBarHeight),
        ),
      ],
      ExploreError() => [
        const SliverFillRemaining(
          hasScrollBody: false,
          child: ExploreEmptyState(
            icon: Icons.error_outline_rounded,
            titleKey: 'explore.error_title',
            bodyKey: 'explore.error_body',
          ),
        ),
      ],
    };
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

    return BlocListener<ExploreCubit, ExploreState>(
      listenWhen: (previous, current) =>
          previous is ExploreLoaded &&
          current is ExploreLoaded &&
          !previous.loadMoreFailed &&
          current.loadMoreFailed,
      listener: (context, _) =>
          AppSnackBar.show(context, message: tr('explore.load_more_failed')),
      child: Stack(
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
                      userLocation:
                          state.userLat != null && state.userLng != null
                          ? LatLng(state.userLat!, state.userLng!)
                          : null,
                      locationButtonBottomPadding:
                          _midSize * MediaQuery.sizeOf(context).height,
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
                            (a, b) => (a - current).abs() < (b - current).abs()
                                ? a
                                : b,
                          );
                        }
                        _sheetController.animateTo(
                          target,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      },
                      child: BlocBuilder<ExploreCubit, ExploreState>(
                        builder: (context, state) => ExploreSheetHeader(
                          state: state,
                          searchController: _searchController,
                          searchFocusNode: _searchFocusNode,
                          onSearch: (q) =>
                              context.read<ExploreCubit>().search(q),
                          onClearSearch: () {
                            _searchController.clear();
                            context.read<ExploreCubit>().search('');
                          },
                        ),
                      ),
                    ),
                    // Scrollable content only.
                    Expanded(
                      child: BlocBuilder<ExploreCubit, ExploreState>(
                        builder: (context, state) =>
                            NotificationListener<ScrollNotification>(
                              onNotification: (notification) {
                                if (notification is ScrollEndNotification &&
                                    notification.metrics.pixels >=
                                        notification.metrics.maxScrollExtent -
                                            200) {
                                  context.read<ExploreCubit>().loadMore();
                                }
                                return false;
                              },
                              child: CustomScrollView(
                                controller: scrollController,
                                physics: const ClampingScrollPhysics(),
                                slivers: _buildSlivers(
                                  context,
                                  state,
                                  navBarHeight,
                                ),
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
