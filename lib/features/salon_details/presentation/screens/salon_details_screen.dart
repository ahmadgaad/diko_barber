import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/features/salon_details/presentation/components/book_now_bar.dart';
import 'package:zain/features/salon_details/presentation/components/coupons_tab.dart';
import 'package:zain/features/salon_details/presentation/components/cover_sliver_app_bar.dart';
import 'package:zain/features/salon_details/presentation/components/gallery_tab.dart';
import 'package:zain/features/salon_details/presentation/components/packages_tab.dart';
import 'package:zain/features/salon_details/presentation/components/reviews_tab.dart';
import 'package:zain/features/salon_details/presentation/components/salon_details_error_view.dart';
import 'package:zain/features/salon_details/presentation/components/salon_details_loading_view.dart';
import 'package:zain/features/salon_details/presentation/components/salon_info_section.dart';
import 'package:zain/features/salon_details/presentation/components/salon_tab_bar_delegate.dart';
import 'package:zain/features/salon_details/presentation/components/services_tab.dart';
import 'package:zain/features/salon_details/presentation/components/shifts_tab.dart';
import 'package:zain/features/salon_details/presentation/components/staff_tab.dart';
import 'package:zain/features/salon_details/presentation/cubit/salon_details_cubit.dart';
import 'package:zain/features/salon_details/presentation/cubit/salon_details_state.dart';

class SalonDetailsScreen extends StatefulWidget {
  const SalonDetailsScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<SalonDetailsScreen> createState() => _SalonDetailsScreenState();
}

class _SalonDetailsScreenState extends State<SalonDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _tabs = [
    'salon_details.tab_services',
    'salon_details.tab_packages',
    'salon_details.tab_coupons',
    'salon_details.tab_staff',
    'salon_details.tab_shifts',
    'salon_details.tab_gallery',
    'salon_details.tab_reviews',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: widget.initialTab.clamp(0, _tabs.length - 1),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocBuilder<SalonDetailsCubit, SalonDetailsState>(
      builder: (context, state) => switch (state) {
        SalonDetailsLoading() => SalonDetailsLoadingView(colors: colors),
        SalonDetailsError() => SalonDetailsErrorView(colors: colors),
        SalonDetailsLoaded() => _LoadedView(
          state: state,
          tabController: _tabController,
          colors: colors,
        ),
      },
    );
  }
}

// ── Loaded view ───────────────────────────────────────────────────────────────

class _LoadedView extends StatelessWidget {
  const _LoadedView({
    required this.state,
    required this.tabController,
    required this.colors,
  });

  final SalonDetailsLoaded state;
  final TabController tabController;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final salon = state.salon;
    return Scaffold(
      backgroundColor: colors.neutral50,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          CoverSliverAppBar(
            salon: salon,
            isFavorite: state.isFavorite,
            colors: colors,
          ),
          SliverToBoxAdapter(
            child: SalonInfoSection(salon: salon, colors: colors),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: SalonTabBarDelegate(
              tabController: tabController,
              colors: colors,
            ),
          ),
        ],
        body: TabBarView(
          controller: tabController,
          children: [
            ServicesTab(
              services: salon.services,
              selectedIds: state.selectedServiceIds,
              colors: colors,
            ),
            PackagesTab(
              packages: salon.packages,
              selectedIds: state.selectedPackageIds,
              colors: colors,
            ),
            CouponsTab(coupons: salon.coupons, colors: colors),
            StaffTab(staff: salon.staff, colors: colors),
            ShiftsTab(shifts: salon.shifts, colors: colors),
            GalleryTab(salonId: salon.id, colors: colors),
            ReviewsTab(salonId: salon.id, colors: colors),
          ],
        ),
      ),
      bottomNavigationBar: BookNowBar(
        salonId: salon.id,
        salonName: salon.name,
        colors: colors,
      ),
    );
  }
}
