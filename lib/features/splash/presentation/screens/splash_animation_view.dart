import 'package:diko_barber/core/cache/cache_keys.dart';
import 'package:diko_barber/core/cache/shared_pref_cache_client.dart';
import 'package:diko_barber/core/di/service_locator.dart';
import 'package:diko_barber/core/resources/image_resources.dart';
import 'package:diko_barber/core/theme/app_colors.dart';
import 'package:diko_barber/features/splash/presentation/components/color_expansion_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/splash_cubit.dart';

class SplashAnimationView extends StatefulWidget {
  const SplashAnimationView({super.key});

  @override
  State<SplashAnimationView> createState() => _SplashAnimationViewState();
}

class _SplashAnimationViewState extends State<SplashAnimationView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _colorExpansionAnimation;
  late final Animation<Alignment> _alignmentAnimation;
  late final Animation<double> _logoOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..addStatusListener(_onAnimationStatus);

    _initAnimations();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<SplashCubit>().startAnimation();
      _controller.forward();
    });
  }

  void _initAnimations() {
    _colorExpansionAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.85, curve: Curves.easeInCubic),
    );

    _alignmentAnimation =
        AlignmentTween(
          begin: const Alignment(0, -1.2),
          end: Alignment.center,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.30, curve: Curves.easeOut),
          ),
        );

    _logoOpacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.80, 1.0, curve: Curves.easeIn),
    );
  }

  void _onAnimationStatus(AnimationStatus status) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (status == AnimationStatus.completed && mounted) {
      sl<SharedPrefCacheClient>().remove(CacheKeys.onboardingSeen);
      await context.read<SplashCubit>().onAnimationComplete();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return SizedBox.expand(
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: ColorExpansionPainter(
                      progress: _colorExpansionAnimation.value,
                      alignment: _alignmentAnimation.value,
                      gradient: splashGradient,
                    ),
                  ),
                ),
                Center(
                  child: FadeTransition(
                    opacity: _logoOpacityAnimation,
                    child: Image.asset(
                      ImageResources.logo,
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
