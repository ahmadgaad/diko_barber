import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';

import '../components/z_light_painter.dart';
import '../cubit/splash_cubit.dart';

class SplashAnimationView extends StatefulWidget {
  const SplashAnimationView({super.key});

  @override
  State<SplashAnimationView> createState() => _SplashAnimationViewState();
}

class _SplashAnimationViewState extends State<SplashAnimationView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _zOpacity;
  late final Animation<double> _lightProgress;
  late final Animation<double> _fadeOut;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..addStatusListener(_onStatus);

    _zOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.15),
    );

    _lightProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.78, curve: Curves.easeInOut),
      ),
    );

    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.85, 1.0, curve: Curves.easeIn),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<SplashCubit>().startAnimation();
      _controller.forward();
    });
  }

  void _onStatus(AnimationStatus status) async {
    if (status == AnimationStatus.completed && mounted) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) await context.read<SplashCubit>().onAnimationComplete();
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
      backgroundColor: splashDark,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(gradient: splashGradient),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => Opacity(
                opacity: (_fadeOut.value * _zOpacity.value).clamp(0.0, 1.0),
                child: SizedBox(
                  width: 160.r,
                  height: 180.r,
                  child: CustomPaint(
                    painter: ZLightPainter(
                      progress: _lightProgress.value,
                      glowColor: splashOrange,
                      letterColor: Colors.white.withValues(alpha: 0.25),
                      strokeWidth: 14.r,
                      glowRadius: 28.r,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
