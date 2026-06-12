import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ronaq_barber/core/widgets/app_error_view.dart';
import 'package:ronaq_barber/core/widgets/app_shimmer.dart';

import '../components/onboarding_page_content.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onHorizontalSwipe(DragEndDetails details, int currentPage, int totalPages) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity.abs() < 300) return;

    if (velocity > 0 && currentPage < totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else if (velocity < 0 && currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingNavigate) {
          context.go(state.target);
          return;
        }
        if (state is OnboardingLoaded && _pageController.hasClients) {
          final current = _pageController.page?.round() ?? 0;
          if (current != state.currentPage) {
            _pageController.animateToPage(
              state.currentPage,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
            );
          }
        }
      },
      builder: (context, state) {
        return switch (state) {
          OnboardingLoading() => const _OnboardingShimmer(),
          OnboardingError(:final message) => AppErrorView(
            message: message,
            onRetry: context.read<OnboardingCubit>().retry,
          ),
          OnboardingLoaded(:final items, :final currentPage) => _buildLayout(
            context,
            items,
            currentPage,
          ),
          OnboardingNavigate() => const SizedBox.shrink(),
        };
      },
    );
  }

  Widget _buildLayout(
    BuildContext context,
    List<dynamic> items,
    int currentPage,
  ) {
    final cubit = context.read<OnboardingCubit>();
    final totalPages = items.length;
    final isLastPage = currentPage == totalPages - 1;
    final item = items[currentPage];

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragEnd: (details) =>
          _onHorizontalSwipe(details, currentPage, totalPages),
      child: Stack(
      children: [
        // Images — physics disabled; swipe is handled by the outer GestureDetector.
        PageView.builder(
          controller: _pageController,
          onPageChanged: cubit.onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: totalPages,
          itemBuilder: (_, index) => Image.network(
            items[index].imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            loadingBuilder: (_, child, progress) => progress == null
                ? child
                : const ColoredBox(color: Colors.black),
            errorBuilder: (context, error, _) =>
                const ColoredBox(color: Colors.black),
          ),
        ),

        // Static dark tint
        const Positioned.fill(child: ColoredBox(color: Color(0x52000000))),

        // Static bottom gradient
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 406.h,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black],
              ),
            ),
          ),
        ),

        // Static language toggle
        // Positioned(top: 70.h, right: 16.w, child: const LanguageToggleButton()),

        // Animated text content — fade + scale for a premium feel
        Positioned(
          top: 507.h,
          left: 16.w,
          right: 16.w,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 320),
            transitionBuilder: (child, animation) {
              final curved = CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              );
              return FadeTransition(
                opacity: curved,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.94, end: 1.0).animate(curved),
                  child: child,
                ),
              );
            },
            child: KeyedSubtree(
              key: ValueKey(currentPage),
              child: OnboardingPageContent(
                heading: item.name,
                body: item.description,
                primaryLabel: isLastPage
                    ? tr('onboarding.sign_in')
                    : tr('onboarding.next'),
                secondaryLabel: isLastPage
                    ? tr('onboarding.sign_up')
                    : tr('onboarding.skip'),
                onPrimary: isLastPage ? cubit.signIn : cubit.onNext,
                onSecondary: isLastPage ? cubit.signUp : cubit.skip,
                pageCount: totalPages,
                currentPage: currentPage,
              ),
            ),
          ),
        ),
      ],
    ),
    );
  }
}

class _OnboardingShimmer extends StatelessWidget {
  const _OnboardingShimmer();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Stack(
        children: [
          Positioned.fill(
            child: ShimmerBox(width: double.infinity, height: double.infinity),
          ),
          Positioned(
            bottom: 60.h,
            left: 16.w,
            right: 16.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ShimmerBox(width: 220.w, height: 28.h, borderRadius: 8.r),
                SizedBox(height: 12.h),
                ShimmerBox(
                  width: double.infinity,
                  height: 20.h,
                  borderRadius: 6.r,
                ),
                SizedBox(height: 6.h),
                ShimmerBox(width: 180.w, height: 20.h, borderRadius: 6.r),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (i) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: ShimmerBox(
                        width: i == 0 ? 24.w : 8.w,
                        height: 8.h,
                        borderRadius: 999.r,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                ShimmerBox(
                  width: double.infinity,
                  height: 52.h,
                  borderRadius: 999.r,
                ),
                SizedBox(height: 12.h),
                ShimmerBox(width: 120.w, height: 20.h, borderRadius: 6.r),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
