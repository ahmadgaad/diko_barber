import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:diko_barber/core/resources/image_resources.dart';
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

  static const _pages = [
    ImageResources.onboarding1,
    ImageResources.onboarding2,
    ImageResources.onboarding3,
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final path in _pages) {
      precacheImage(AssetImage(path), context);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onStateChanged(BuildContext context, OnboardingState state) {
    switch (state) {
      case OnboardingInitial():
        final cubit = context.read<OnboardingCubit>();
        _pageController.animateToPage(
          cubit.currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      case OnboardingNavigate(:final target):
        context.go(target);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: _onStateChanged,
      child: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
          final cubit = context.read<OnboardingCubit>();
          final totalPages = _pages.length;
          final isLastPage = cubit.currentPage == totalPages - 1;

          return PageView.builder(
            controller: _pageController,
            onPageChanged: cubit.onPageChanged,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: totalPages,
            itemBuilder: (context, index) {
              final headingKey = 'onboarding.screen_${index + 1}.heading';
              final bodyKey = 'onboarding.screen_${index + 1}.body';
              return OnboardingPageContent(
                imagePath: _pages[index],
                heading: tr(headingKey),
                body: tr(bodyKey),
                primaryLabel: isLastPage
                    ? tr('onboarding.sign_in')
                    : tr('onboarding.next'),
                secondaryLabel: isLastPage
                    ? tr('onboarding.sign_up')
                    : tr('onboarding.skip'),
                onPrimary: isLastPage ? cubit.signIn : () => cubit.onNext(totalPages),
                onSecondary: isLastPage ? cubit.signUp : cubit.skip,
                pageCount: totalPages,
                currentPage: cubit.currentPage,
              );
            },
          );
        },
      ),
    );
  }
}
