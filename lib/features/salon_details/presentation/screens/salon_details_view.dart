import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/shared/domain/entities/package.dart';
import 'package:ronaq_barber/core/shared/domain/entities/review.dart';
import 'package:ronaq_barber/core/shared/domain/entities/salon_details.dart';
import 'package:ronaq_barber/core/shared/domain/entities/salon_service.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/features/salon_details/presentation/cubit/salon_details_cubit.dart';
import 'package:ronaq_barber/features/salon_details/presentation/cubit/salon_details_state.dart';
import 'package:shimmer/shimmer.dart';

class SalonDetailsView extends StatefulWidget {
  const SalonDetailsView({super.key});

  @override
  State<SalonDetailsView> createState() => _SalonDetailsViewState();
}

class _SalonDetailsViewState extends State<SalonDetailsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _tabs = [
    'salon_details.tab_services',
    'salon_details.tab_packages',
    'salon_details.tab_gallery',
    'salon_details.tab_reviews',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
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
        SalonDetailsLoading() => _LoadingView(colors: colors),
        SalonDetailsError() => _ErrorView(colors: colors),
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
          _CoverSliverAppBar(
            salon: salon,
            isFavorite: state.isFavorite,
            colors: colors,
          ),
          SliverToBoxAdapter(
            child: _SalonInfoSection(salon: salon, colors: colors),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              tabController: tabController,
              colors: colors,
            ),
          ),
        ],
        body: TabBarView(
          controller: tabController,
          children: [
            _ServicesTab(services: salon.services, colors: colors),
            _PackagesTab(packages: salon.packages, colors: colors),
            _GalleryTab(gallery: salon.gallery, colors: colors),
            _ReviewsTab(reviews: salon.reviews, colors: colors),
          ],
        ),
      ),
      bottomNavigationBar: _BookNowBar(colors: colors),
    );
  }
}

// ── Cover SliverAppBar ────────────────────────────────────────────────────────

class _CoverSliverAppBar extends StatelessWidget {
  const _CoverSliverAppBar({
    required this.salon,
    required this.isFavorite,
    required this.colors,
  });

  final SalonDetails salon;
  final bool isFavorite;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 240.h,
      pinned: true,
      backgroundColor: colors.neutral50,
      surfaceTintColor: Colors.transparent,
      leading: _CircleIconButton(
        icon: Icons.arrow_back_ios_new_rounded,
        onTap: () => Navigator.of(context).pop(),
      ),
      actions: [
        _CircleIconButton(
          icon: isFavorite
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          iconColor: isFavorite ? splashOrange : Colors.white,
          onTap: () => context.read<SalonDetailsCubit>().toggleFavorite(),
        ),
        SizedBox(width: 8.w),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: salon.coverImage,
              fit: BoxFit.cover,
              placeholder: (_, _) =>
                  Container(color: colors.neutral200),
              errorWidget: (_, _, _) => Container(
                color: colors.neutral200,
                alignment: Alignment.center,
                child: Icon(
                  Icons.store_outlined,
                  color: colors.neutral400,
                  size: 48.r,
                ),
              ),
            ),
            // Gradient overlay
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.white,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.r,
        height: 36.r,
        margin: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 18.r),
      ),
    );
  }
}

// ── Salon info section ────────────────────────────────────────────────────────

class _SalonInfoSection extends StatelessWidget {
  const _SalonInfoSection({required this.salon, required this.colors});

  final SalonDetails salon;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.neutral50,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + rating row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  salon.name,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.neutral900,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              _RatingBadge(rating: salon.rating, colors: colors),
            ],
          ),
          SizedBox(height: 6.h),
          // Review count + distance + open status
          Row(
            children: [
              Icon(Icons.reviews_outlined,
                  size: 14.r, color: colors.neutral500),
              SizedBox(width: 4.w),
              Text(
                '${salon.reviewCount} ${tr('salon_details.reviews')}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: colors.neutral500,
                ),
              ),
              SizedBox(width: 10.w),
              _Dot(colors: colors),
              SizedBox(width: 10.w),
              Icon(Icons.location_on_outlined,
                  size: 14.r, color: colors.neutral500),
              SizedBox(width: 4.w),
              Text(
                '${salon.distance.toStringAsFixed(1)} ${tr('home.km')}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: colors.neutral500,
                ),
              ),
              SizedBox(width: 10.w),
              _Dot(colors: colors),
              SizedBox(width: 10.w),
              Text(
                tr(salon.isOpen ? 'home.open' : 'home.closed'),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: salon.isOpen ? colors.success500 : colors.error500,
                ),
              ),
              if (salon.isOpen && salon.closingTime != null) ...[
                Text(
                  ' · ${salon.closingTime}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colors.neutral500,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 8.h),
          // Address
          Row(
            children: [
              Icon(Icons.map_outlined, size: 14.r, color: colors.neutral400),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  salon.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colors.neutral500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          // Categories
          if (salon.categories.isNotEmpty)
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: salon.categories.map((cat) {
                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: colors.primary50,
                    borderRadius: BorderRadius.circular(999.r),
                    border: Border.all(color: colors.primary200),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.primary500,
                    ),
                  ),
                );
              }).toList(),
            ),
          SizedBox(height: 10.h),
          // Description
          Text(
            salon.description,
            style: TextStyle(
              fontSize: 13.sp,
              height: 1.6,
              color: colors.neutral600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating, required this.colors});

  final double rating;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E7),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFFFC107).withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, color: const Color(0xFFFFC107), size: 14.r),
          SizedBox(width: 3.w),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF6B4F00),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3.w,
      height: 3.w,
      decoration: BoxDecoration(
        color: colors.neutral400,
        shape: BoxShape.circle,
      ),
    );
  }
}

// ── Tab bar delegate ──────────────────────────────────────────────────────────

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  const _TabBarDelegate({required this.tabController, required this.colors});

  final TabController tabController;
  final AppColors colors;

  static const _tabs = [
    'salon_details.tab_services',
    'salon_details.tab_packages',
    'salon_details.tab_gallery',
    'salon_details.tab_reviews',
  ];

  @override
  double get minExtent => 46;
  @override
  double get maxExtent => 46;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: colors.neutral50,
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: splashOrange, width: 2),
          insets: EdgeInsets.symmetric(horizontal: 4.w),
        ),
        indicatorColor: splashOrange,
        labelColor: splashOrange,
        unselectedLabelColor: colors.neutral500,
        labelStyle: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
        ),
        dividerColor: colors.neutral200,
        tabs: _tabs.map((key) => Tab(text: tr(key))).toList(),
      ),
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) =>
      oldDelegate.colors != colors;
}

// ── Services tab ──────────────────────────────────────────────────────────────

class _ServicesTab extends StatelessWidget {
  const _ServicesTab({required this.services, required this.colors});

  final List<SalonService> services;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      physics: const BouncingScrollPhysics(),
      itemCount: services.length,
      separatorBuilder: (_, _) => SizedBox(height: 10.h),
      itemBuilder: (context, i) =>
          _ServiceTile(service: services[i], colors: colors),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({required this.service, required this.colors});

  final SalonService service;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: CachedNetworkImage(
              imageUrl: service.image,
              width: 72.r,
              height: 72.r,
              fit: BoxFit.cover,
              placeholder: (_, _) =>
                  Container(width: 72.r, height: 72.r, color: colors.neutral200),
              errorWidget: (_, _, _) => Container(
                width: 72.r,
                height: 72.r,
                color: colors.neutral200,
                alignment: Alignment.center,
                child: Icon(Icons.content_cut_rounded,
                    color: colors.neutral400, size: 24.r),
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
                    fontWeight: FontWeight.w600,
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
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.timer_outlined,
                        size: 13.r, color: colors.neutral400),
                    SizedBox(width: 3.w),
                    Text(
                      '${service.durationMinutes} ${tr('salon_details.min')}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: colors.neutral500,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(Icons.star_rounded,
                        size: 13.r, color: const Color(0xFFFFC107)),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${service.price.toInt()} ${tr('home.currency')}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: splashOrange,
                ),
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: splashOrange,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    tr('home.book_now'),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Packages tab ──────────────────────────────────────────────────────────────

class _PackagesTab extends StatelessWidget {
  const _PackagesTab({required this.packages, required this.colors});

  final List<Package> packages;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      physics: const BouncingScrollPhysics(),
      itemCount: packages.length,
      separatorBuilder: (_, _) => SizedBox(height: 10.h),
      itemBuilder: (context, i) =>
          _PackageTile(package: packages[i], colors: colors),
    );
  }
}

class _PackageTile extends StatelessWidget {
  const _PackageTile({required this.package, required this.colors});

  final Package package;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.neutral200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover image with gradient overlay
          SizedBox(
            height: 120.h,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: package.image,
                  fit: BoxFit.cover,
                  placeholder: (_, _) =>
                      Container(color: colors.neutral200),
                  errorWidget: (_, _, _) => Container(
                    color: colors.neutral200,
                    alignment: Alignment.center,
                    child: Icon(Icons.spa_outlined,
                        color: colors.neutral400, size: 32.r),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10.h,
                  left: 12.w,
                  right: 12.w,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          package.name,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: splashOrange,
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Text(
                          '${package.price.toInt()} ${tr('home.currency')}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        package.description,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: colors.neutral600,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(Icons.star_rounded,
                              size: 13.r, color: const Color(0xFFFFC107)),
                          SizedBox(width: 3.w),
                          Text(
                            package.rating.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: colors.neutral700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: splashOrange,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      tr('home.book_now'),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Gallery tab ───────────────────────────────────────────────────────────────

class _GalleryTab extends StatelessWidget {
  const _GalleryTab({required this.gallery, required this.colors});

  final List<String> gallery;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(12.w),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 6.w,
        mainAxisSpacing: 6.h,
      ),
      itemCount: gallery.length,
      itemBuilder: (context, i) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: CachedNetworkImage(
            imageUrl: gallery[i],
            fit: BoxFit.cover,
            placeholder: (_, _) => Container(color: colors.neutral200),
            errorWidget: (_, _, _) => Container(
              color: colors.neutral200,
              alignment: Alignment.center,
              child:
                  Icon(Icons.image_outlined, color: colors.neutral400, size: 24.r),
            ),
          ),
        );
      },
    );
  }
}

// ── Reviews tab ───────────────────────────────────────────────────────────────

class _ReviewsTab extends StatelessWidget {
  const _ReviewsTab({required this.reviews, required this.colors});

  final List<Review> reviews;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      physics: const BouncingScrollPhysics(),
      itemCount: reviews.length,
      separatorBuilder: (_, _) => SizedBox(height: 10.h),
      itemBuilder: (context, i) =>
          _ReviewCard(review: reviews[i], colors: colors),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review, required this.colors});

  final Review review;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: review.userAvatar,
                  width: 38.r,
                  height: 38.r,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(
                      width: 38.r, height: 38.r, color: colors.neutral200),
                  errorWidget: (_, _, _) => Container(
                    width: 38.r,
                    height: 38.r,
                    color: colors.neutral200,
                    alignment: Alignment.center,
                    child: Icon(Icons.person_outline,
                        color: colors.neutral400, size: 20.r),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.neutral900,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      DateFormat('dd MMM yyyy', context.locale.languageCode)
                          .format(review.createdAt),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: colors.neutral400,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < review.rating.round()
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 14.r,
                    color: const Color(0xFFFFC107),
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 13.sp,
              color: colors.neutral700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Book Now bottom bar ───────────────────────────────────────────────────────

class _BookNowBar extends StatelessWidget {
  const _BookNowBar({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: colors.neutral50,
        border: Border(top: BorderSide(color: colors.neutral200)),
      ),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 52.h,
          decoration: const BoxDecoration(
            gradient: buttonGradient,
            borderRadius: BorderRadius.all(Radius.circular(999)),
          ),
          alignment: Alignment.center,
          child: Text(
            tr('salon_details.book_now'),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Loading view ──────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.neutral50,
      body: Shimmer.fromColors(
        baseColor: colors.neutral200,
        highlightColor: colors.neutral100,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(height: 240.h, color: colors.neutral200),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 200.w,
                        height: 24.h,
                        color: colors.neutral200),
                    SizedBox(height: 8.h),
                    Container(
                        width: double.infinity,
                        height: 16.h,
                        color: colors.neutral200),
                    SizedBox(height: 6.h),
                    Container(
                        width: 160.w,
                        height: 16.h,
                        color: colors.neutral200),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error view ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.neutral50,
      appBar: AppBar(
        backgroundColor: colors.neutral50,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: colors.neutral900),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 56.r, color: colors.neutral300),
            SizedBox(height: 12.h),
            Text(
              tr('explore.error_title'),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: colors.neutral700,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              tr('explore.error_body'),
              style: TextStyle(
                fontSize: 13.sp,
                color: colors.neutral500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
