import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ronaq_barber/core/resources/svg_resources.dart';
import 'package:ronaq_barber/core/shared/domain/entities/coupon.dart';
import 'package:ronaq_barber/core/shared/domain/entities/salon.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/features/home/presentation/components/coupons_section.dart';
import 'package:ronaq_barber/features/search/presentation/cubit/search_cubit.dart';
import 'package:ronaq_barber/features/search/presentation/cubit/search_state.dart';
import 'package:shimmer/shimmer.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) context.read<SearchCubit>().search(value);
    });
  }

  void _onSubmit(String value) {
    _debounce?.cancel();
    context.read<SearchCubit>().submitSearch(value);
    _focusNode.unfocus();
  }

  void _onClear() {
    _controller.clear();
    context.read<SearchCubit>().clearQuery();
    _focusNode.requestFocus();
  }

  void _onResultTap(Salon salon) {
    _focusNode.unfocus();
    context.read<SearchCubit>().selectSalon(salon);
    context.push('/salon/${salon.id}');
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      children: [
        _SearchBar(
          controller: _controller,
          focusNode: _focusNode,
          colors: colors,
          onChanged: _onChanged,
          onSubmit: _onSubmit,
          onClear: _onClear,
        ),
        Divider(height: 1, color: colors.neutral200),
        Expanded(
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) => switch (state) {
              SearchLoading() => _SearchShimmer(colors: colors),
              SearchIdle() => _IdleBody(
                  state: state,
                  colors: colors,
                  onRecentTap: _onResultTap,
                ),
              SearchActive() => _ActiveBody(
                  state: state,
                  colors: colors,
                  onResultTap: _onResultTap,
                ),
            },
          ),
        ),
      ],
    );
  }
}

// ── Search bar ────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.colors,
    required this.onChanged,
    required this.onSubmit,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final AppColors colors;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmit;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.all(6.r),
              child: Transform.scale(
                scaleX: Directionality.of(context) == TextDirection.rtl
                    ? -1
                    : 1,
                child: SvgPicture.asset(
                  SvgResources.arrowBack,
                  width: 22.r,
                  height: 22.r,
                  colorFilter:
                      ColorFilter.mode(colors.neutral900, BlendMode.srcIn),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Container(
              height: 46.h,
              decoration: BoxDecoration(
                color: colors.neutral100,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: colors.neutral200),
              ),
              child: Row(
                children: [
                  SizedBox(width: 12.w),
                  SvgPicture.asset(
                    SvgResources.search,
                    width: 18.r,
                    height: 18.r,
                    colorFilter: ColorFilter.mode(
                        colors.neutral400, BlendMode.srcIn),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Stack(
                      alignment: AlignmentDirectional.centerStart,
                      children: [
                        ValueListenableBuilder(
                          valueListenable: controller,
                          builder: (_, value, _) => value.text.isEmpty
                              ? _AnimatedHint(colors: colors)
                              : const SizedBox.shrink(),
                        ),
                        TextField(
                          controller: controller,
                          focusNode: focusNode,
                          onChanged: onChanged,
                          onSubmitted: onSubmit,
                          textInputAction: TextInputAction.search,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: colors.neutral900,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: controller,
                    builder: (_, value, _) {
                      if (value.text.isEmpty) return const SizedBox.shrink();
                      return GestureDetector(
                        onTap: onClear,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Container(
                            width: 18.r,
                            height: 18.r,
                            decoration: BoxDecoration(
                              color: colors.neutral300,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.close_rounded,
                                size: 11.r, color: colors.neutral700),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Idle body ─────────────────────────────────────────────────────────────────

class _IdleBody extends StatelessWidget {
  const _IdleBody({
    required this.state,
    required this.colors,
    required this.onRecentTap,
  });

  final SearchIdle state;
  final AppColors colors;
  final ValueChanged<Salon> onRecentTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.recentSalons.isNotEmpty) ...[
            SizedBox(height: 16.h),
            _RecentSearches(
              recents: state.recentSalons,
              colors: colors,
              onTap: onRecentTap,
            ),
          ],
          SizedBox(height: 20.h),
          _SectionHeader(title: tr('search.trending'), colors: colors),
          SizedBox(height: 12.h),
          _TrendingSalons(salons: state.trendingSalons, colors: colors),
          SizedBox(height: 24.h),
          _SectionHeader(title: tr('search.hot_offers'), colors: colors),
          SizedBox(height: 12.h),
          _HotOffers(coupons: state.hotOffers),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

// ── Recent searches ───────────────────────────────────────────────────────────

class _RecentSearches extends StatelessWidget {
  const _RecentSearches({
    required this.recents,
    required this.colors,
    required this.onTap,
  });

  final List<Salon> recents;
  final AppColors colors;
  final ValueChanged<Salon> onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tr('search.recent_searches'),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.neutral900,
                ),
              ),
              GestureDetector(
                onTap: () => context.read<SearchCubit>().clearRecents(),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Text(
                    tr('search.clear_all'),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: splashOrange,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          ...recents.map((s) => _RecentItem(
                salon: s,
                colors: colors,
                onTap: () => onTap(s),
                onRemove: () =>
                    context.read<SearchCubit>().removeRecent(s.id),
              )),
        ],
      ),
    );
  }
}

class _RecentItem extends StatelessWidget {
  const _RecentItem({
    required this.salon,
    required this.colors,
    required this.onTap,
    required this.onRemove,
  });

  final Salon salon;
  final AppColors colors;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 9.h),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: CachedNetworkImage(
                imageUrl: salon.image,
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
                  child: Icon(Icons.store_outlined,
                      color: colors.neutral400, size: 20.r),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                salon.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: colors.neutral800,
                ),
              ),
            ),
            GestureDetector(
              onTap: onRemove,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsetsDirectional.only(start: 8.w),
                child: Icon(
                  Icons.close_rounded,
                  size: 18.r,
                  color: colors.neutral400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.colors});
  final String title;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          color: colors.neutral900,
        ),
      ),
    );
  }
}

// ── Trending salons ───────────────────────────────────────────────────────────

class _TrendingSalons extends StatelessWidget {
  const _TrendingSalons({required this.salons, required this.colors});
  final List<Salon> salons;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: salons.map((s) {
          return Padding(
            padding: EdgeInsetsDirectional.only(end: 12.w),
            child: GestureDetector(
              onTap: () => context.push('/salon/${s.id}'),
              child: _TrendingCard(salon: s, colors: colors),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TrendingCard extends StatelessWidget {
  const _TrendingCard({required this.salon, required this.colors});
  final Salon salon;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: CachedNetworkImage(
                  imageUrl: salon.image,
                  width: 150.w,
                  height: 106.h,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(
                    width: 150.w,
                    height: 106.h,
                    decoration: BoxDecoration(
                      color: colors.neutral200,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  errorWidget: (_, _, _) => Container(
                    width: 150.w,
                    height: 106.h,
                    decoration: BoxDecoration(
                      color: colors.neutral200,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.store_outlined,
                        color: colors.neutral400, size: 28.r),
                  ),
                ),
              ),
              if (salon.isOpen)
                PositionedDirectional(
                  top: 7.h,
                  start: 7.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: colors.success500,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      tr('home.open'),
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 7.h),
          Text(
            salon.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: colors.neutral900,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Icon(Icons.star_rounded,
                  color: const Color(0xFFFFC107), size: 13.r),
              SizedBox(width: 2.w),
              Text(
                salon.averageRating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: colors.neutral600,
                ),
              ),
              SizedBox(width: 5.w),
              Container(
                width: 2.r,
                height: 2.r,
                decoration: BoxDecoration(
                  color: colors.neutral400,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 5.w),
              Text(
                salon.distance?.formatted ?? '-',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: colors.neutral500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Hot offers ────────────────────────────────────────────────────────────────

class _HotOffers extends StatelessWidget {
  const _HotOffers({required this.coupons});
  final List<Coupon> coupons;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: coupons.map((c) {
          return Padding(
            padding: EdgeInsetsDirectional.only(end: 16.w),
            child: CouponCard(coupon: c),
          );
        }).toList(),
      ),
    );
  }
}

// ── Active body (search results) ──────────────────────────────────────────────

class _ActiveBody extends StatelessWidget {
  const _ActiveBody({
    required this.state,
    required this.colors,
    required this.onResultTap,
  });
  final SearchActive state;
  final AppColors colors;
  final ValueChanged<Salon> onResultTap;

  @override
  Widget build(BuildContext context) {
    if (state.results.isEmpty) {
      return _EmptyState(query: state.query, colors: colors);
    }
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: state.results.length,
      separatorBuilder: (_, _) =>
          Divider(height: 1, color: colors.neutral200),
      itemBuilder: (_, i) => _ResultTile(
        salon: state.results[i],
        colors: colors,
        onTap: () => onResultTap(state.results[i]),
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({
    required this.salon,
    required this.colors,
    required this.onTap,
  });
  final Salon salon;
  final AppColors colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CachedNetworkImage(
                imageUrl: salon.image,
                width: 56.r,
                height: 56.r,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                  width: 56.r,
                  height: 56.r,
                  color: colors.neutral200,
                ),
                errorWidget: (_, _, _) => Container(
                  width: 56.r,
                  height: 56.r,
                  color: colors.neutral200,
                  alignment: Alignment.center,
                  child: Icon(Icons.store_outlined,
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
                    salon.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.neutral900,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.star_rounded,
                          color: const Color(0xFFFFC107), size: 13.r),
                      SizedBox(width: 3.w),
                      Text(
                        salon.averageRating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: colors.neutral600,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 7.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: salon.isOpen
                              ? colors.success500.withValues(alpha: 0.12)
                              : colors.neutral200,
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Text(
                          tr(salon.isOpen ? 'home.open' : 'home.closed'),
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: salon.isOpen
                                ? colors.success600
                                : colors.neutral500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Wrap(
                    spacing: 4.w,
                    children: salon.categories.take(2).map((c) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 7.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: colors.neutral100,
                          borderRadius: BorderRadius.circular(999.r),
                          border: Border.all(color: colors.neutral200),
                        ),
                        child: Text(
                          c,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: colors.neutral600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              SvgResources.chevronRight,
              width: 18.r,
              height: 18.r,
              colorFilter:
                  ColorFilter.mode(colors.neutral400, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query, required this.colors});
  final String query;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.r,
              height: 80.r,
              decoration: BoxDecoration(
                color: colors.neutral100,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.search_off_rounded,
                  size: 38.r, color: colors.neutral400),
            ),
            SizedBox(height: 16.h),
            Text(
              tr('search.no_results_title'),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: colors.neutral800,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              '"$query"',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.sp,
                color: splashOrange,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              tr('search.no_results_body'),
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 13.sp, color: colors.neutral500),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Animated hint ─────────────────────────────────────────────────────────────
//
// Static prefix + vertical ticker keyword.
// ClipRect keeps the sliding keyword contained to the hint line.

class _AnimatedHint extends StatefulWidget {
  const _AnimatedHint({required this.colors});
  final AppColors colors;

  @override
  State<_AnimatedHint> createState() => _AnimatedHintState();
}

class _AnimatedHintState extends State<_AnimatedHint>
    with SingleTickerProviderStateMixin {
  static const _keys = [
    'search.hint_1',
    'search.hint_2',
    'search.hint_3',
    'search.hint_4',
    'search.hint_5',
    'search.hint_6',
  ];

  int _current = 0;
  int _next = 1;
  Timer? _timer;
  late final AnimationController _ctrl;
  late final Animation<double> _slideOut; // current → up
  late final Animation<double> _slideIn;  // next → center
  late final Animation<double> _fadeOut;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );

    _slideOut = Tween<double>(begin: 0.0, end: -1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeIn),
    );
    _slideIn = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.5)),
    );
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.5, 1.0)),
    );

    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _tick());
  }

  void _tick() {
    if (!mounted) return;
    _ctrl.forward(from: 0).then((_) {
      if (!mounted) return;
      setState(() {
        _current = _next;
        _next = (_next + 1) % _keys.length;
      });
      _ctrl.reset();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  TextStyle get _style => TextStyle(
        fontSize: 14.sp,
        color: widget.colors.neutral400,
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(tr('search.hint_prefix'), style: _style),
        ClipRect(
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, _) {
              return SizedBox(
                height: 20.h,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // outgoing keyword slides up + fades
                    FractionalTranslation(
                      translation: Offset(0, _slideOut.value),
                      child: Opacity(
                        opacity: _fadeOut.value,
                        child: Text(
                          tr(_keys[_current]),
                          style: _style,
                        ),
                      ),
                    ),
                    // incoming keyword slides in from below + fades in
                    FractionalTranslation(
                      translation: Offset(0, _slideIn.value),
                      child: Opacity(
                        opacity: _fadeIn.value,
                        child: Text(
                          tr(_keys[_next]),
                          style: _style,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Shimmer ───────────────────────────────────────────────────────────────────

class _SearchShimmer extends StatelessWidget {
  const _SearchShimmer({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    Widget block(double w, double h, [double r = 6]) => Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: colors.neutral200,
            borderRadius: BorderRadius.circular(r.r),
          ),
        );

    return Shimmer.fromColors(
      baseColor: colors.neutral200,
      highlightColor: colors.neutral100,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            block(140.w, 18.h),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: List.generate(
                  4,
                  (i) => block(
                      [80.w, 100.w, 70.w, 90.w][i], 32.h, 999)),
            ),
            SizedBox(height: 24.h),
            block(130.w, 18.h),
            SizedBox(height: 12.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                children: List.generate(3, (_) {
                  return Padding(
                    padding: EdgeInsetsDirectional.only(end: 12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        block(150.w, 106.h, 14),
                        SizedBox(height: 7.h),
                        block(100.w, 14.h),
                        SizedBox(height: 5.h),
                        block(70.w, 11.h),
                      ],
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 24.h),
            block(100.w, 18.h),
            SizedBox(height: 12.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                children: List.generate(2, (_) {
                  return Padding(
                    padding: EdgeInsetsDirectional.only(end: 16.w),
                    child: block(310.w, 120.h, 16),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
